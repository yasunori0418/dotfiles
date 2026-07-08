"""resume_check の純粋関数に対するテスト。

副作用（`wt list` 実行）を伴う run_wt_list/main は対象外。find_plan_candidates は
実ファイル走査を行うため tmp_path 上の実ファイルで検証する。
"""
from pathlib import Path

from resume_check import find_plan_candidates, is_dirty, render, summarize_lanes


# ---- is_dirty ----

def test_is_dirty_all_false() -> None:
    """観点: working_tree の全フラグが false なら dirty=False。"""
    wt = {"staged": False, "modified": False, "untracked": False, "renamed": False, "deleted": False}
    assert is_dirty(wt) is False


def test_is_dirty_one_true() -> None:
    """観点: 1つでも true があれば dirty=True。"""
    assert is_dirty({"staged": False, "modified": True, "untracked": False}) is True


def test_is_dirty_empty_dict() -> None:
    """観点: working_tree が空dict（キー欠如）でも例外を出さず False。"""
    assert is_dirty({}) is False


# ---- find_plan_candidates ----

def test_find_plan_candidates_matches_filename(tmp_path: Path) -> None:
    """観点: ブランチ名そのものをファイル名に含む計画ファイルがヒットする。"""
    (tmp_path / "feat-envelope-info-warnings.md").write_text("計画本文")
    (tmp_path / "unrelated.md").write_text("関係ない内容")
    hits = find_plan_candidates("feat-envelope-info-warnings", tmp_path)
    assert hits == [str(tmp_path / "feat-envelope-info-warnings.md")]


def test_find_plan_candidates_matches_content_token(tmp_path: Path) -> None:
    """観点: ファイル名は一致しなくても、本文にブランチ由来の3文字以上トークンがあればヒットする。"""
    (tmp_path / "20260707-plan.md").write_text("対象ブランチ: spec/skipped-vocabulary の作業")
    hits = find_plan_candidates("spec/skipped-vocabulary", tmp_path)
    assert hits == [str(tmp_path / "20260707-plan.md")]


def test_find_plan_candidates_no_match(tmp_path: Path) -> None:
    """観点: どのファイルにもブランチ名由来トークンが無ければ空リスト。"""
    (tmp_path / "other.md").write_text("まったく別件の計画")
    assert find_plan_candidates("feat-x", tmp_path) == []


def test_find_plan_candidates_missing_dir(tmp_path: Path) -> None:
    """観点: plans_dir が存在しなくても例外を出さず空リスト。"""
    assert find_plan_candidates("feat-x", tmp_path / "does-not-exist") == []


def test_find_plan_candidates_ignores_generic_branch_name(tmp_path: Path) -> None:
    """観点: main のような汎用ブランチ名は、内容に'main'を含む無関係な計画にも
    ヒットしてしまうため、候補として拾わない（実運用で10件誤ヒットした事象の回帰）。
    """
    (tmp_path / "unrelated-plan.md").write_text("base branch: main への PR を作成する")
    assert find_plan_candidates("main", tmp_path) == []


def test_find_plan_candidates_ignores_generic_prefix_tokens(tmp_path: Path) -> None:
    """観点: `test/xxx` のような git-flow 接頭辞由来の汎用トークン(test)単体では
    ヒットせず、具体的なトークン(decode-conformance側)がある場合のみヒットする。
    """
    (tmp_path / "p1.md").write_text("test 実行に関する一般的なメモ")
    (tmp_path / "p2.md").write_text("go-decode-conformance のテスト計画")
    hits = find_plan_candidates("test/go-decode-conformance", tmp_path)
    assert hits == [str(tmp_path / "p2.md")]


def test_find_plan_candidates_requires_all_tokens_together(tmp_path: Path) -> None:
    """観点: 複数トークンのうち一部（flake・lock）だけが出現し bump が無い計画は
    拾わない（実運用で `chore/bump-flake-lock` が無関係な計画6件に誤ヒットした事象の回帰）。
    """
    (tmp_path / "unrelated.md").write_text("flake.lock を更新した話（別件）")
    (tmp_path / "matched.md").write_text("bump対応でflake関連のlockファイルを更新")
    hits = find_plan_candidates("chore/bump-flake-lock", tmp_path)
    assert hits == [str(tmp_path / "matched.md")]


def test_find_plan_candidates_single_token_ignores_content_only_match(tmp_path: Path) -> None:
    """観点: 非汎用トークンが1つだけのブランチは、本文だけの一致では拾わない
    （単語1つの本文一致は精度が低いため）。ファイル名に含む場合のみヒットする。
    """
    (tmp_path / "content-only.md").write_text("prototype という単語が出てくるだけの無関係な計画")
    (tmp_path / "prototype-plan.md").write_text("本文はこの内容に限らない")
    hits = find_plan_candidates("prototype", tmp_path)
    assert hits == [str(tmp_path / "prototype-plan.md")]


# ---- summarize_lanes ----

def test_summarize_lanes_flags_dirty_and_ahead(tmp_path: Path) -> None:
    """観点: dirty または ahead>0 のレーンだけが needs_action に入る。"""
    entries = [
        {
            "branch": "main",
            "path": "/repo",
            "working_tree": {"staged": False, "modified": False, "untracked": False},
            "remote": {"ahead": 0, "behind": 0},
        },
        {
            "branch": "feat-a",
            "path": "/repo-feat-a",
            "working_tree": {"staged": True, "modified": False, "untracked": False},
            "remote": {"ahead": 0, "behind": 0},
        },
        {
            "branch": "feat-b",
            "path": "/repo-feat-b",
            "working_tree": {"staged": False, "modified": False, "untracked": False},
            "remote": {"ahead": 2, "behind": 0},
        },
    ]
    summary = summarize_lanes(entries, tmp_path)
    assert len(summary["lanes"]) == 3
    needs = {lane["branch"] for lane in summary["needs_action"]}
    assert needs == {"feat-a", "feat-b"}


def test_summarize_lanes_missing_remote_defaults_to_zero(tmp_path: Path) -> None:
    """観点: remote キーが欠けていても KeyError を出さず ahead/behind=0 として扱う。"""
    entries = [{"branch": "feat-c", "path": "/repo-feat-c", "working_tree": {}}]
    summary = summarize_lanes(entries, tmp_path)
    assert summary["lanes"][0]["ahead"] == 0
    assert summary["lanes"][0]["behind"] == 0
    assert summary["needs_action"] == []


# ---- render ----

def test_render_includes_lane_and_needs_action_sections(tmp_path: Path) -> None:
    """観点: 出力に LANES/NEEDS ACTION の両セクションと該当ブランチ名が含まれる。"""
    entries = [
        {
            "branch": "feat-a",
            "path": "/repo-feat-a",
            "working_tree": {"staged": True},
            "remote": {"ahead": 0, "behind": 0},
        }
    ]
    summary = summarize_lanes(entries, tmp_path)
    text = render(summary)
    assert "=== LANES ===" in text
    assert "=== NEEDS ACTION" in text
    assert "feat-a" in text


def test_render_needs_action_none_when_all_clean(tmp_path: Path) -> None:
    """観点: dirty も ahead>0 も無いときは NEEDS ACTION セクションが (none) になる。"""
    entries = [
        {
            "branch": "main",
            "path": "/repo",
            "working_tree": {"staged": False},
            "remote": {"ahead": 0, "behind": 0},
        }
    ]
    summary = summarize_lanes(entries, tmp_path)
    text = render(summary)
    assert "(none)" in text
