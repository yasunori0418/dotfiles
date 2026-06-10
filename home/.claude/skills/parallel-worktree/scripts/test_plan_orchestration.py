"""plan_orchestration の純粋関数に対するテスト。

副作用（I/O）は read_spec/main に隔離してあるので、ここでは純粋関数
（parse_spec / analyze / detect_cycle / compute_levels / resolve_base / sanitize / render）
のみを検証する。各テスト関数の docstring に「何を担保するテストか」を記す。
"""
import pytest

from plan_orchestration import (
    SpecError,
    analyze,
    compute_levels,
    detect_cycle,
    parse_spec,
    render,
    resolve_base,
    sanitize,
)


def mk(tasks, default_base="main"):
    return parse_spec({"default_base": default_base, "tasks": tasks})


# ---- parse_spec ----

def test_parse_spec_minimal():
    """観点: 最小 spec（id/branch のみ）で default_base が main、depends_on が空になる正常系。"""
    plan = mk([{"id": "A", "branch": "feat-a"}])
    assert plan.default_base == "main"
    assert plan.tasks[0].id == "A"
    assert plan.tasks[0].branch == "feat-a"
    assert plan.tasks[0].depends_on == ()


def test_parse_spec_rejects_non_dict():
    """観点: トップレベルが dict でない壊れた spec を SpecError で弾く（構造破綻の早期検出）。"""
    with pytest.raises(SpecError):
        parse_spec([1, 2, 3])


def test_parse_spec_rejects_empty_tasks():
    """観点: tasks が空配列のとき SpecError。空オーケストレーションを生成させない。"""
    with pytest.raises(SpecError):
        parse_spec({"tasks": []})


def test_parse_spec_rejects_bad_depends_on():
    """観点: depends_on が配列でない（文字列など）型不正を SpecError で弾く。"""
    with pytest.raises(SpecError):
        parse_spec({"tasks": [{"id": "A", "branch": "b", "depends_on": "B"}]})


# ---- sanitize ----

@pytest.mark.parametrize("raw,expected", [
    ("feat/foo-bar", "feat-foo-bar"),
    ("feat_a", "feat_a"),
    ("--weird--", "weird"),
    ("###", "wt"),
])
def test_sanitize(raw, expected):
    """観点: tmux セッション名生成。スラッシュ等の不正文字をハイフン化し、前後ハイフン除去、全滅時は 'wt' に退避。"""
    assert sanitize(raw) == expected


# ---- detect_cycle ----

def test_detect_cycle_none_when_acyclic():
    """観点: 非循環の依存グラフでは None を返す（誤検出しない）。"""
    plan = mk([
        {"id": "A", "branch": "a"},
        {"id": "B", "branch": "b", "depends_on": ["A"]},
    ])
    assert detect_cycle(plan) is None


def test_detect_cycle_found():
    """観点: A↔B の相互依存（循環）を検出して経路を返す。デッドロックする計画を未然に止める。"""
    plan = mk([
        {"id": "A", "branch": "a", "depends_on": ["B"]},
        {"id": "B", "branch": "b", "depends_on": ["A"]},
    ])
    assert detect_cycle(plan) is not None


# ---- compute_levels ----

def test_compute_levels_linear_stack():
    """観点: 線形 stack（S1→S2→S3）でレベルが 0,1,2 と単調増加する＝起動ウェーブが正しく段になる。"""
    plan = mk([
        {"id": "S1", "branch": "s1"},
        {"id": "S2", "branch": "s2", "depends_on": ["S1"]},
        {"id": "S3", "branch": "s3", "depends_on": ["S2"]},
    ])
    lv = compute_levels(plan)
    assert lv == {"S1": 0, "S2": 1, "S3": 2}


def test_compute_levels_independent_all_zero():
    """観点: 独立タスクは全て level 0＝同一ウェーブで並列起動できると算出される。"""
    plan = mk([
        {"id": "A", "branch": "a"},
        {"id": "B", "branch": "b"},
    ])
    assert compute_levels(plan) == {"A": 0, "B": 0}


# ---- resolve_base ----

def test_resolve_base_independent_uses_default():
    """観点: 依存なしタスクの base がデフォルトブランチ（main）に解決される。"""
    plan = mk([{"id": "A", "branch": "a"}])
    by_id = {t.id: t for t in plan.tasks}
    assert resolve_base(plan.tasks[0], by_id, "main") == "main"


def test_resolve_base_stacked_uses_parent_branch():
    """観点: stacked タスクの base が親タスクの『ブランチ名』に解決される（id ではなく branch を base にする）。"""
    plan = mk([
        {"id": "A", "branch": "feat-a"},
        {"id": "B", "branch": "feat-b", "depends_on": ["A"]},
    ])
    by_id = {t.id: t for t in plan.tasks}
    assert resolve_base(by_id["B"], by_id, "main") == "feat-a"


# ---- analyze ----

def test_analyze_mixed_parallel_and_stack():
    """観点: 並列(A,B1)と stack(B1→B2)が混在する spec で、レベルと base が一括で正しく算出される統合ケース。"""
    plan = mk([
        {"id": "A", "branch": "refactor-logger"},
        {"id": "B1", "branch": "feat-config-retry"},
        {"id": "B2", "branch": "feat-client-retry", "depends_on": ["B1"]},
    ])
    an = analyze(plan)
    assert an.errors == []
    assert an.levels == {"A": 0, "B1": 0, "B2": 1}
    assert an.bases["B2"] == "feat-config-retry"
    assert an.bases["A"] == "main"


def test_analyze_reports_duplicate_branch():
    """観点: ブランチ名の重複を致命的エラーとして報告し、エラー時は levels を算出しない（壊れた計画で先へ進まない）。"""
    plan = mk([
        {"id": "A", "branch": "dup"},
        {"id": "B", "branch": "dup"},
    ])
    an = analyze(plan)
    assert any("branch が重複" in e for e in an.errors)
    assert an.levels == {}  # 致命的エラー時は算出しない


def test_analyze_reports_unknown_dependency():
    """観点: 存在しない id への depends_on を致命的エラーとして検出する（タイプミス等の早期検出）。"""
    plan = mk([{"id": "A", "branch": "a", "depends_on": ["X"]}])
    an = analyze(plan)
    assert any("未定義" in e for e in an.errors)


def test_analyze_reports_cycle():
    """観点: analyze が detect_cycle の結果をエラーとして取り込む（循環がエラー一覧に現れる）。"""
    plan = mk([
        {"id": "A", "branch": "a", "depends_on": ["B"]},
        {"id": "B", "branch": "b", "depends_on": ["A"]},
    ])
    an = analyze(plan)
    assert any("循環" in e for e in an.errors)


def test_analyze_warns_on_multiple_parents():
    """観点: 複数親依存は致命的ではなく警告扱い。線形 stack 不可を知らせつつ続行可能にする。"""
    plan = mk([
        {"id": "A", "branch": "a"},
        {"id": "B", "branch": "b"},
        {"id": "C", "branch": "c", "depends_on": ["A", "B"]},
    ])
    an = analyze(plan)
    assert an.errors == []
    assert any("複数親" in w for w in an.warnings)


# ---- render ----

def test_render_independent_has_no_base_flag():
    """観点: 独立タスクの起動コマンドに --base が付かない（不要な base 指定でノイズを出さない）。"""
    plan = mk([{"id": "A", "branch": "feat-a", "prompt": "do A"}])
    out = render(plan, analyze(plan))
    assert "wt switch --create feat-a -x claude" in out
    assert "--base" not in out  # 独立タスクは base 指定なし


def test_render_stacked_includes_base_and_ordering():
    """観点: stacked タスクで --base 指定・wave 表示・/pr-create の base 引数が出力に揃って現れる。"""
    plan = mk([
        {"id": "S1", "branch": "s1", "prompt": "p1"},
        {"id": "S2", "branch": "s2", "depends_on": ["S1"], "prompt": "p2"},
    ])
    out = render(plan, analyze(plan))
    assert "--base s1" in out
    assert "wave 1" in out
    assert "/pr-create s1" in out  # stacked PR の base 指定


def test_render_errors_skips_commands():
    """観点: 致命的エラーがあるとき render はコマンド列を出さず ERROR のみ提示する（誤った計画を実行させない）。"""
    plan = mk([{"id": "A", "branch": "a", "depends_on": ["X"]}])
    out = render(plan, analyze(plan))
    assert "ERROR" in out
    assert "COMMANDS" not in out  # 致命的エラー時はコマンドを出さない
