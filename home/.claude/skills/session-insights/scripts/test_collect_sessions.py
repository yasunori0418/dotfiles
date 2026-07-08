#!/usr/bin/env python3
"""collect_sessions.py のテスト。

実行: uv run --project "<skill-dir>" pytest
（unittest 形式なので `uv run --project "<skill-dir>" python <このファイル>` でも可）

純粋層（レコード解釈・reduce_session・レポート整形）は合成レコードで検証し、
副作用層（ファイル走査・CLI）は一時ディレクトリに合成 JSONL を置いて
end-to-end で検証する。実環境の ~/.claude には一切触れない。
"""
from __future__ import annotations

import io
import json
import tempfile
import unittest
from contextlib import redirect_stdout
from datetime import datetime, timezone
from pathlib import Path

import collect_sessions as cs


# ============================================================
# 合成レコードのヘルパ
# ============================================================


def user_rec(text, ts="2026-07-01T03:00:00.000Z", **extra):
    rec = {
        "type": "user",
        "timestamp": ts,
        "cwd": "/home/u/proj",
        "gitBranch": "main",
        "version": "2.1.200",
        "message": {"role": "user", "content": text},
    }
    rec.update(extra)
    return rec


def assistant_rec(blocks, usage=None, model="claude-fable-5", ts="2026-07-01T03:01:00.000Z"):
    return {
        "type": "assistant",
        "timestamp": ts,
        "message": {"role": "assistant", "model": model, "content": blocks, "usage": usage or {}},
    }


def tool_use(name, tool_input, tool_id="tu_1"):
    return {"type": "tool_use", "id": tool_id, "name": name, "input": tool_input}


# ============================================================
# 純粋層: 基本変換
# ============================================================


class TestBasics(unittest.TestCase):
    def test_parse_ts_valid(self):
        dt = cs.parse_ts("2026-06-27T13:13:23.686Z")
        assert dt is not None
        self.assertEqual(dt.tzinfo, timezone.utc)
        self.assertEqual(dt.year, 2026)

    def test_parse_ts_invalid(self):
        self.assertIsNone(cs.parse_ts(None))
        self.assertIsNone(cs.parse_ts(12345))
        self.assertIsNone(cs.parse_ts("not-a-date"))

    def test_jst_str_converts_to_jst(self):
        dt = cs.parse_ts("2026-06-27T15:00:00.000Z")  # UTC 15:00 → JST 翌0:00
        self.assertEqual(cs.jst_str(dt), "2026-06-28 00:00 JST")
        self.assertEqual(cs.jst_str(dt, seconds=True), "2026-06-28 00:00:00 JST")
        self.assertIsNone(cs.jst_str(None))

    def test_parse_jst_date(self):
        dt = cs.parse_jst_date("2026-07-01")
        assert dt is not None
        self.assertEqual((dt.year, dt.month, dt.day), (2026, 7, 1))
        self.assertEqual(dt.tzinfo, cs.JST)
        self.assertIsNone(cs.parse_jst_date(None))
        self.assertIsNone(cs.parse_jst_date("07/01"))

    def test_human_duration(self):
        self.assertEqual(cs.human_duration(5), "5s")
        self.assertEqual(cs.human_duration(65), "1m05s")
        self.assertEqual(cs.human_duration(3665), "1h01m")
        self.assertIsNone(cs.human_duration(None))
        self.assertIsNone(cs.human_duration(-1))

    def test_truncate(self):
        self.assertEqual(cs.truncate("abc", 10), "abc")
        self.assertEqual(cs.truncate("abcdef", 3), "abc…(+3字)")
        self.assertEqual(cs.truncate("abcdef", 0), "abcdef")  # 0 = 無制限

    def test_in_range_until_inclusive(self):
        since = cs.parse_jst_date("2026-07-01")
        until = cs.parse_jst_date("2026-07-02")
        inside = datetime(2026, 7, 2, 23, 59, tzinfo=cs.JST)
        outside = datetime(2026, 7, 3, 0, 0, tzinfo=cs.JST)
        self.assertTrue(cs.in_range(inside, since, until))
        self.assertFalse(cs.in_range(outside, since, until))
        self.assertFalse(cs.in_range(datetime(2026, 6, 30, tzinfo=cs.JST), since, until))


class TestTokenUsage(unittest.TestCase):
    def test_from_api_usage(self):
        u = cs.TokenUsage.from_api_usage(
            {
                "input_tokens": 10,
                "output_tokens": 20,
                "cache_read_input_tokens": 30,
                "cache_creation_input_tokens": 40,
                "extra_field": "ignored",
            }
        )
        self.assertEqual((u.input, u.output, u.cache_read, u.cache_creation), (10, 20, 30, 40))
        self.assertEqual(u.context_size, 80)

    def test_from_api_usage_tolerant(self):
        self.assertEqual(cs.TokenUsage.from_api_usage(None), cs.TokenUsage())
        self.assertEqual(cs.TokenUsage.from_api_usage({"input_tokens": "bad"}).input, 0)

    def test_add_is_immutable(self):
        a = cs.TokenUsage(input=1)
        b = cs.TokenUsage(input=2, output=5)
        c = a + b
        self.assertEqual(c.input, 3)
        self.assertEqual(c.output, 5)
        self.assertEqual(a.input, 1)  # 元は不変

    def test_as_dict(self):
        d = cs.TokenUsage(input=1, output=2).as_dict()
        self.assertEqual(d, {"input": 1, "output": 2, "cache_read": 0, "cache_creation": 0})


# ============================================================
# 純粋層: レコード解釈
# ============================================================


class TestPromptText(unittest.TestCase):
    def test_plain_prompt(self):
        self.assertEqual(cs.prompt_text(user_rec("バグを直して")), "バグを直して")

    def test_excludes_meta_and_sidechain_and_compact(self):
        self.assertIsNone(cs.prompt_text(user_rec("x", isMeta=True)))
        self.assertIsNone(cs.prompt_text(user_rec("x", isSidechain=True)))
        self.assertIsNone(cs.prompt_text(user_rec("x", isCompactSummary=True)))

    def test_excludes_command_echo_and_stdout(self):
        self.assertIsNone(cs.prompt_text(user_rec("<command-name>/mcp</command-name>")))
        self.assertIsNone(cs.prompt_text(user_rec("<local-command-stdout>ok</local-command-stdout>")))

    def test_excludes_caveat_and_notifications(self):
        self.assertIsNone(cs.prompt_text(user_rec("Caveat: the messages below...")))
        self.assertIsNone(cs.prompt_text(user_rec("<task-notification>done</task-notification>")))
        self.assertIsNone(cs.prompt_text(user_rec("<system-reminder>x</system-reminder>")))

    def test_excludes_tool_result_only(self):
        rec = user_rec([{"type": "tool_result", "tool_use_id": "tu_1", "content": "ok"}])
        self.assertIsNone(cs.prompt_text(rec))

    def test_text_blocks_joined(self):
        rec = user_rec([{"type": "text", "text": "a"}, {"type": "text", "text": "b"}])
        self.assertEqual(cs.prompt_text(rec), "a\nb")

    def test_non_user_record(self):
        self.assertIsNone(cs.prompt_text({"type": "assistant"}))


class TestRecordHelpers(unittest.TestCase):
    def test_extract_command_names(self):
        text = "<command-name>/commit-flow</command-name> x <command-name>/mcp</command-name>"
        self.assertEqual(cs.extract_command_names(text), ["/commit-flow", "/mcp"])
        self.assertEqual(cs.extract_command_names(None), [])

    def test_tool_brief_priority_and_truncation(self):
        self.assertEqual(cs.tool_brief({"command": "ls -la"}), "ls -la")
        self.assertEqual(cs.tool_brief({"description": "説明", "command": "ls"}), "説明")
        self.assertEqual(cs.tool_brief("not-a-dict"), "")
        long = cs.tool_brief({"command": "x" * 200})
        self.assertTrue(long.startswith("x" * 100))

    def test_tool_result_errors_maps_tool_name(self):
        rec = user_rec(
            [
                {"type": "tool_result", "tool_use_id": "tu_9", "is_error": True, "content": "boom\nline2"},
                {"type": "tool_result", "tool_use_id": "tu_x", "content": "fine"},
            ]
        )
        errs = cs.tool_result_errors(rec, {"tu_9": "Bash"})
        self.assertEqual(len(errs), 1)
        self.assertEqual(errs[0].tool, "Bash")
        self.assertEqual(errs[0].message, "boom line2")

    def test_tool_result_errors_content_list(self):
        rec = user_rec(
            [
                {
                    "type": "tool_result",
                    "tool_use_id": "tu_1",
                    "is_error": True,
                    "content": [{"type": "text", "text": "err"}],
                }
            ]
        )
        errs = cs.tool_result_errors(rec, {})
        self.assertEqual(errs[0].message, "err")
        self.assertEqual(errs[0].tool, "?")


# ============================================================
# 純粋層: セッション畳み込み
# ============================================================


def synthetic_records():
    """代表的なレコード型を一通り含む合成セッション。"""
    return [
        {"type": "permission-mode", "permissionMode": "acceptEdits", "sessionId": "s1"},
        {"type": "ai-title", "aiTitle": "テストセッション", "sessionId": "s1"},
        user_rec("最初の依頼", ts="2026-07-01T03:00:00.000Z"),
        assistant_rec(
            [
                {"type": "text", "text": "了解"},
                tool_use("Bash", {"command": "ls"}, "tu_1"),
                tool_use("Skill", {"skill": "commit-flow"}, "tu_2"),
                tool_use("Task", {"subagent_type": "Explore"}, "tu_3"),
            ],
            usage={
                "input_tokens": 100,
                "output_tokens": 50,
                "cache_read_input_tokens": 1000,
                "cache_creation_input_tokens": 200,
            },
            ts="2026-07-01T03:01:00.000Z",
        ),
        user_rec(
            [{"type": "tool_result", "tool_use_id": "tu_1", "is_error": True, "content": "exit 1"}],
            ts="2026-07-01T03:02:00.000Z",
        ),
        {
            "type": "system",
            "subtype": "compact_boundary",
            "timestamp": "2026-07-01T03:03:00.000Z",
            "compactMetadata": {"trigger": "auto", "preTokens": 150000},
        },
        {"type": "system", "subtype": "turn_duration", "durationMs": 60000},
        {
            "type": "system",
            "subtype": "local_command",
            "content": "<command-name>/mcp</command-name>",
            "timestamp": "2026-07-01T03:04:00.000Z",
        },
        {"type": "pr-link", "prUrl": "https://github.com/o/r/pull/1", "sessionId": "s1"},
        user_rec("<command-name>/commit-flow</command-name>", ts="2026-07-01T03:05:00.000Z"),
        assistant_rec(
            [{"type": "text", "text": "完了"}],
            usage={"input_tokens": 10, "output_tokens": 5, "cache_read_input_tokens": 2000},
            ts="2026-07-01T03:06:00.000Z",
        ),
    ]


class TestReduceSession(unittest.TestCase):
    def setUp(self):
        self.s = cs.reduce_session("s1", "-home-u-proj", synthetic_records())

    def test_metadata(self):
        self.assertEqual(self.s.session_id, "s1")
        self.assertEqual(self.s.title, "テストセッション")
        self.assertEqual(self.s.cwd, "/home/u/proj")
        self.assertEqual(self.s.git_branch, "main")
        self.assertFalse(self.s.spawned_as_agent)
        self.assertEqual(self.s.permission_modes, {"acceptEdits"})
        self.assertEqual(self.s.pr_links, ["https://github.com/o/r/pull/1"])

    def test_time_range(self):
        self.assertEqual(cs.jst_str(self.s.first), "2026-07-01 12:00 JST")
        self.assertEqual(cs.jst_str(self.s.last), "2026-07-01 12:06 JST")
        self.assertEqual(self.s.duration_sec, 360)

    def test_prompts_exclude_command_echo(self):
        self.assertEqual([p.text for p in self.s.prompts], ["最初の依頼"])

    def test_tools_skills_agents(self):
        self.assertEqual(self.s.tools, {"Bash": 1, "Skill": 1, "Task": 1})
        self.assertEqual(self.s.skills, {"commit-flow": 1})
        self.assertEqual(self.s.agents, {"Explore": 1})

    def test_commands_from_user_and_system(self):
        self.assertEqual(self.s.commands, {"/commit-flow": 1, "/mcp": 1})

    def test_usage_and_peak(self):
        self.assertEqual(self.s.usage.input, 110)
        self.assertEqual(self.s.usage.output, 55)
        self.assertEqual(self.s.usage.cache_read, 3000)
        # peak = max(100+1000+200, 10+2000+0)
        self.assertEqual(self.s.peak_context, 2010)

    def test_error_maps_to_tool(self):
        self.assertEqual(len(self.s.errors), 1)
        self.assertEqual(self.s.errors[0].tool, "Bash")

    def test_compaction_and_turns(self):
        self.assertEqual(len(self.s.compactions), 1)
        self.assertEqual(self.s.compactions[0].trigger, "auto")
        self.assertEqual(self.s.turn_ms, [60000])

    def test_agent_spawned_session(self):
        recs = [{"type": "agent-setting", "agentSetting": "Explore"}]
        s = cs.reduce_session("s2", "p", recs)
        self.assertTrue(s.spawned_as_agent)
        self.assertEqual(s.agent_type, "Explore")

    def test_tolerant_of_garbage(self):
        garbage: list = [None, "str", {}, {"type": "unknown-future-type"}]
        s = cs.reduce_session("s3", "p", garbage)
        self.assertEqual(s.assistant_msgs, 0)
        self.assertEqual(len(s.prompts), 0)


# ============================================================
# 純粋層: レポート整形
# ============================================================


class TestReports(unittest.TestCase):
    def setUp(self):
        self.stats = cs.reduce_session("abcdef12-3456", "-home-u-proj", synthetic_records())
        self.filters = cs.SessionFilters(project="proj")

    def test_summarize_session_fields(self):
        self.stats.subagent_files = 2
        d = cs.summarize_session(self.stats)
        self.assertEqual(d["session_id"], "abcdef12-3456")
        self.assertEqual(d["prompts"], 1)
        self.assertEqual(d["subagent_files"], 2)
        self.assertEqual(d["errors"], 1)
        self.assertEqual(d["duration"], "6m00s")
        self.assertIsNone(d["spawned_as_agent"])
        self.assertEqual(d["usage"]["input"], 110)

    def test_sessions_report_limit_and_aggregate(self):
        rep = cs.sessions_report([self.stats, self.stats], self.filters, limit=1)
        self.assertEqual(rep["total_matched"], 2)
        self.assertEqual(rep["shown"], 1)
        self.assertEqual(rep["aggregate"]["prompts"], 1)
        self.assertEqual(rep["aggregate"]["usage"]["input"], 110)

    def test_prompts_report_truncation(self):
        rep = cs.prompts_report([self.stats], self.filters, limit=10, max_chars=3)
        self.assertEqual(rep["total_prompts"], 1)
        self.assertTrue(rep["prompts"][0]["text"].startswith("最初の"))
        self.assertEqual(rep["prompts"][0]["chars"], len("最初の依頼"))

    def test_tools_report(self):
        rep = cs.tools_report([self.stats], self.filters, by_project=True)
        self.assertEqual(rep["tools"]["Bash"], 1)
        self.assertEqual(rep["skills"], {"commit-flow": 1})
        self.assertIn("-home-u-proj", rep["by_project"])

    def test_usage_report_by_day(self):
        rep = cs.usage_report([self.stats], self.filters, by="day")
        self.assertEqual(rep["usage_total"]["input"], 110)
        self.assertEqual(rep["compactions"]["count"], 1)
        self.assertEqual(rep["compactions"]["avg_pre_tokens"], 150000)
        self.assertIn("2026-07-01", rep["by_day"])

    def test_errors_report(self):
        rep = cs.errors_report([self.stats], self.filters, limit=10, max_chars=100)
        self.assertEqual(rep["total_errors"], 1)
        self.assertEqual(rep["by_tool"], {"Bash": 1})

    def test_commands_report_with_history(self):
        history = [
            {"display": "/mcp", "timestamp": 1780000000000, "project": "/home/u/proj"},
            {"display": "普通のプロンプト", "timestamp": 1780000000000, "project": "/home/u/proj"},
            {"display": "/mcp", "timestamp": 1780000000000, "project": "/other"},
        ]
        rep = cs.commands_report([self.stats], history, cs.SessionFilters(project="proj"))
        self.assertEqual(rep["from_transcripts"]["/commit-flow"], 1)
        self.assertEqual(rep["from_history"]["total_prompts"], 2)
        self.assertEqual(rep["from_history"]["slash_commands"], {"/mcp": 1})

    def test_transcript_turns(self):
        turns = cs.transcript_turns(synthetic_records(), max_chars=100, include_tools=True)
        roles = [t["role"] for t in turns]
        self.assertEqual(
            roles, ["user", "assistant", "assistant:tools", "system", "assistant"]
        )
        self.assertEqual(turns[0]["text"], "最初の依頼")
        self.assertEqual(turns[2]["tools"][0], {"tool": "Bash", "brief": "ls"})
        self.assertIn("compact", turns[3]["text"])


class TestCcusageArgv(unittest.TestCase):
    def test_daily_with_range(self):
        argv = cs.ccusage_argv("2026-07-01", "2026-07-08", None)
        self.assertEqual(
            argv,
            [
                "claude",
                "daily",
                "--json",
                "--timezone",
                "Asia/Tokyo",
                "--since",
                "2026-07-01",
                "--until",
                "2026-07-08",
            ],
        )

    def test_session_id_takes_precedence(self):
        argv = cs.ccusage_argv(None, None, "abc123")
        self.assertEqual(argv[:4], ["claude", "session", "--id", "abc123"])
        self.assertIn("--json", argv)

    def test_no_filters(self):
        self.assertEqual(
            cs.ccusage_argv(None, None, None),
            ["claude", "daily", "--json", "--timezone", "Asia/Tokyo"],
        )


class TestConfigHelpers(unittest.TestCase):
    def test_parse_frontmatter_text(self):
        text = '---\nname: foo\ndescription: "説明 です"\ndisable-model-invocation: true\n---\n# 本文\nname: 偽物\n'
        fm = cs.parse_frontmatter_text(text)
        self.assertEqual(fm["name"], "foo")
        self.assertEqual(fm["description"], "説明 です")
        self.assertEqual(fm["disable-model-invocation"], "true")
        self.assertNotIn("本文の name", fm.values())

    def test_parse_frontmatter_no_marker(self):
        self.assertEqual(cs.parse_frontmatter_text("# タイトルのみ"), {})

    def test_redact_settings(self):
        obj = {
            "env": {"GITHUB_TOKEN": "abc", "MY_API_KEY": "xyz", "PLAIN": "ok"},
            "list": [{"password": "p"}],
            "count": 3,
        }
        red: dict = cs.redact_settings(obj)
        self.assertEqual(red["env"]["GITHUB_TOKEN"], "«redacted»")
        self.assertEqual(red["env"]["MY_API_KEY"], "«redacted»")
        self.assertEqual(red["env"]["PLAIN"], "ok")
        self.assertEqual(red["list"][0]["password"], "«redacted»")
        self.assertEqual(red["count"], 3)

    def test_skill_inventory_entry(self):
        text = "---\nname: demo\ndescription: d\ndisable-model-invocation: true\n---\nbody"
        e = cs.skill_inventory_entry("demo-dir", text, {"scripts"})
        self.assertEqual(e["name"], "demo")
        self.assertTrue(e["disable_model_invocation"])
        self.assertTrue(e["has_scripts"])
        self.assertFalse(e["has_references"])


class TestSessionFilters(unittest.TestCase):
    def test_as_dict_omits_empty(self):
        f = cs.SessionFilters(project="x")
        self.assertEqual(f.as_dict(), {"project": "x"})
        self.assertEqual(cs.SessionFilters().as_dict(), {})

    def test_include_agents_visible(self):
        f = cs.SessionFilters(include_agents=True)
        self.assertEqual(f.as_dict(), {"include_agents": True})


class TestResolveConfigDir(unittest.TestCase):
    def test_priority(self):
        d, src = cs.resolve_config_dir("/tmp/x", env={"CLAUDE_CONFIG_DIR": "/tmp/y"})
        self.assertEqual((str(d), src), ("/tmp/x", "cli:--config-dir"))
        d, src = cs.resolve_config_dir(None, env={"CLAUDE_CONFIG_DIR": "/tmp/y"})
        self.assertEqual((str(d), src), ("/tmp/y", "env:CLAUDE_CONFIG_DIR"))
        d, src = cs.resolve_config_dir(None, env={})
        self.assertEqual(src, "default:~/.claude")
        self.assertTrue(str(d).endswith("/.claude"))


# ============================================================
# 副作用層: 一時ディレクトリでの end-to-end
# ============================================================


class TestCli(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        root = Path(self.tmp.name)
        proj = root / "projects" / "-home-u-proj"
        proj.mkdir(parents=True)
        with open(proj / "aaaa1111-0000-0000-0000-000000000000.jsonl", "w") as f:
            for rec in synthetic_records():
                f.write(json.dumps(rec, ensure_ascii=False) + "\n")
        # Agent 起動由来のセッション（既定で除外されるべき）
        with open(proj / "bbbb2222-0000-0000-0000-000000000000.jsonl", "w") as f:
            recs = [{"type": "agent-setting", "agentSetting": "Explore"}] + synthetic_records()
            for rec in recs:
                f.write(json.dumps(rec, ensure_ascii=False) + "\n")
        (root / "history.jsonl").write_text(
            json.dumps({"display": "/mcp", "timestamp": 1780000000000, "project": "/home/u/proj"})
            + "\n"
        )
        (root / "skills" / "demo").mkdir(parents=True)
        (root / "skills" / "demo" / "SKILL.md").write_text(
            "---\nname: demo\ndescription: デモ\n---\n# demo\n"
        )
        (root / "settings.json").write_text(json.dumps({"env": {"MY_TOKEN": "secret"}}))
        self.root = root

    def tearDown(self):
        self.tmp.cleanup()

    def run_cli(self, *argv) -> dict:
        buf = io.StringIO()
        with redirect_stdout(buf):
            code = cs.main(["--config-dir", str(self.root), *argv])
        self.assertEqual(code, 0)
        return json.loads(buf.getvalue())

    def test_sessions_excludes_agent_spawned_by_default(self):
        rep = self.run_cli("sessions")
        self.assertEqual(rep["total_matched"], 1)
        self.assertEqual(rep["sessions"][0]["session_id"], "aaaa1111-0000-0000-0000-000000000000")

    def test_sessions_include_agents(self):
        rep = self.run_cli("sessions", "--include-agents")
        self.assertEqual(rep["total_matched"], 2)

    def test_prompts(self):
        rep = self.run_cli("prompts")
        self.assertEqual(rep["total_prompts"], 1)
        self.assertEqual(rep["prompts"][0]["text"], "最初の依頼")

    def test_tools(self):
        rep = self.run_cli("tools")
        self.assertEqual(rep["skills"], {"commit-flow": 1})

    def test_commands_reads_history(self):
        rep = self.run_cli("commands")
        self.assertEqual(rep["from_history"]["slash_commands"], {"/mcp": 1})

    def test_config_redacts_and_lists_skills(self):
        rep = self.run_cli("config")
        self.assertEqual(rep["settings.json"]["env"]["MY_TOKEN"], "«redacted»")
        self.assertEqual(rep["skills"][0]["name"], "demo")

    def test_transcript_by_prefix(self):
        rep = self.run_cli("transcript", "--session", "aaaa1111")
        self.assertEqual(rep["session"]["session_id"], "aaaa1111-0000-0000-0000-000000000000")
        self.assertEqual(rep["turns"][0]["text"], "最初の依頼")

    def test_usage_builtin_engine_has_no_ccusage_section(self):
        rep = self.run_cli("usage", "--engine", "builtin", "--by", "day")
        self.assertEqual(rep["usage_total"]["input"], 110)
        self.assertNotIn("ccusage", rep)

    def test_paths_runs(self):
        rep = self.run_cli("paths")
        self.assertEqual(rep["projects"]["session_files"], 2)
        self.assertTrue(rep["entries"]["skills/"]["exists"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
