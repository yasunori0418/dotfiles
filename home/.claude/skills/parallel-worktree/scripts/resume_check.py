#!/usr/bin/env python3
"""parallel-worktree のクラッシュ・強制終了復旧チェック(決定論 CLI)。

PC の強制終了・クラッシュ等でセッションが不意に中断されたとき、`wt list` で
判明する全レーン（worktree）の状態（未コミット変更・未 push コミット）と、
対応する計画ファイル（既定 `~/.claude/plans/`）の候補を機械的に一覧化する。
AI はこの出力を土台に、レーンごとの次アクション（push・/pr-create・実装続行）
をユーザーに要約する。状態を変える操作は一切行わない（read-only）。

実行（cwd 非依存。uv が skill 直下の pyproject.toml から .venv を構築して実行）:
    uv run --project "<skill-dir>" python "<skill-dir>/scripts/resume_check.py"
    ... -C <path> で対象リポジトリを明示（未指定なら cwd）
    ... --plans-dir <dir> で計画ファイルの検索先を上書き（既定 ~/.claude/plans）
    ... --json で人間向けテキストを省き JSON のみ出力

依存は stdlib のみ。`wt` コマンドが PATH にある前提。
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path


def run_wt_list(cwd: str | None) -> list[dict]:
    proc = subprocess.run(
        ["wt", "list", "--format", "json"],
        cwd=cwd,
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        print(f"ERROR: wt list に失敗: {proc.stderr.strip()}", file=sys.stderr)
        sys.exit(1)
    try:
        return json.loads(proc.stdout)
    except json.JSONDecodeError as e:
        print(f"ERROR: wt list の出力を JSON として解釈できない: {e}", file=sys.stderr)
        sys.exit(1)


def is_dirty(working_tree: dict) -> bool:
    """observed: staged/modified/untracked/renamed/deleted のいずれかが true なら未コミット変更ありとみなす。"""
    return any(working_tree.get(k) for k in ("staged", "modified", "untracked", "renamed", "deleted"))


_GENERIC_TOKENS = {
    "main", "master", "develop", "feat", "feature", "fix", "test", "spec",
    "docs", "doc", "chore", "build", "ci", "refactor", "perf", "style",
    "hotfix", "release",
}


def find_plan_candidates(branch: str, plans_dir: Path) -> list[str]:
    """計画ファイル（*.md）のうち、ブランチ名を**ファイル名に**含むもの、または
    `/`,`-`,`_` 区切りの4文字以上・非汎用（git-flow接頭辞や main 等を除いた）
    トークンが2つ以上あり、それら**全て**が本文に揃って出現するものを候補として返す。

    自由記述の計画ファイルは "flake"/"lock"/"decode" のような単語が無関係な計画にも
    単発で出現しがちなので、本文一致は複数トークンの AND 一致のみを信用する
    （単一トークンや汎用語だけでの本文一致は候補にしない）。
    """
    if not plans_dir.is_dir():
        return []
    tokens = [
        t for t in re.split(r"[/_-]", branch)
        if len(t) >= 4 and t.lower() not in _GENERIC_TOKENS
    ]
    hits = []
    for f in sorted(plans_dir.glob("*.md")):
        if branch in f.name:
            hits.append(str(f))
            continue
        if len(tokens) < 2:
            continue
        try:
            content = f.read_text(errors="ignore")
        except OSError:
            content = ""
        haystack = f.name + "\n" + content
        if all(t in haystack for t in tokens):
            hits.append(str(f))
    return hits


def summarize_lanes(entries: list[dict], plans_dir: Path) -> dict:
    lanes = []
    needs_action = []
    for e in entries:
        branch = e.get("branch", "?")
        path = e.get("path", "?")
        dirty = is_dirty(e.get("working_tree") or {})
        remote = e.get("remote") or {}
        ahead = remote.get("ahead", 0) or 0
        behind = remote.get("behind", 0) or 0
        plans = find_plan_candidates(branch, plans_dir)
        lane = {
            "branch": branch,
            "path": path,
            "dirty": dirty,
            "ahead": ahead,
            "behind": behind,
            "plan_candidates": plans,
        }
        lanes.append(lane)
        if dirty or ahead > 0:
            needs_action.append(lane)
    return {"lanes": lanes, "needs_action": needs_action}


def render(summary: dict) -> str:
    lines = ["=== LANES ==="]
    for lane in summary["lanes"]:
        lines.append(f"- branch={lane['branch']} path={lane['path']}")
        lines.append(f"  dirty={lane['dirty']} ahead={lane['ahead']} behind={lane['behind']}")
        plans = lane["plan_candidates"]
        lines.append("  plan_candidates=" + (", ".join(plans) if plans else "(none)"))
    lines.append("")
    lines.append("=== NEEDS ACTION (未コミット or 未push) ===")
    if not summary["needs_action"]:
        lines.append("(none)")
    else:
        for lane in summary["needs_action"]:
            lines.append(f"- {lane['branch']}: dirty={lane['dirty']} ahead={lane['ahead']} behind={lane['behind']}")
    return "\n".join(lines)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("-C", dest="cwd", default=None, help="対象リポジトリ（未指定なら cwd）")
    ap.add_argument(
        "--plans-dir",
        default=str(Path.home() / ".claude" / "plans"),
        help="計画ファイルの検索先（既定 ~/.claude/plans）",
    )
    ap.add_argument("--json", action="store_true", help="人間向けテキストの代わりに JSON のみ出力")
    args = ap.parse_args()

    entries = run_wt_list(args.cwd)
    summary = summarize_lanes(entries, Path(args.plans_dir))

    if args.json:
        print(json.dumps(summary, ensure_ascii=False))
    else:
        print(render(summary))
        print()
        print("=== JSON ===")
        print(json.dumps(summary, ensure_ascii=False))


if __name__ == "__main__":
    main()
