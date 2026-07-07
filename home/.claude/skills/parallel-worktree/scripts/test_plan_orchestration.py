"""plan_orchestration の純粋関数に対するテスト。

副作用（I/O）は read_spec/main に隔離してあるので、ここでは純粋関数
（parse_spec / analyze / detect_cycle / compute_levels / resolve_base / sanitize / render）
のみを検証する。各テスト関数の docstring に「何を担保するテストか」を記す。
"""
import pytest

from plan_orchestration import (
    Launch,
    SpecError,
    analyze,
    compute_levels,
    detect_cycle,
    launch_flags,
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


def test_render_remote_control_injects_flag():
    """観点: remote_control=True で各 claude が --remote-control <ブランチ名> 付きで起動され、
    名前が tmux セッション名（sanitize 済みブランチ）に揃い、prompt がその後ろに来る。"""
    plan = mk([{"id": "A", "branch": "feat/foo", "prompt": "do A"}])
    out = render(plan, analyze(plan), Launch(remote_control=True))
    # sanitize('feat/foo') == 'feat-foo'。-x claude の -- 以降に名前→prompt の順で並ぶ。
    # inner 全体が tmux 行で再度 shlex.quote されるため prompt 部分のクォートは確認せず、
    # 素通しで残る --remote-control <名前> 部分を検証する。
    assert "-x claude -- --remote-control feat-foo " in out
    assert "tmux new-session -d -s feat-foo" in out


def test_render_without_remote_control_has_no_flag():
    """観点: 既定（remote_control=False）では --remote-control を一切出さない（オプトイン）。"""
    plan = mk([{"id": "A", "branch": "feat-a", "prompt": "do A"}])
    out = render(plan, analyze(plan))
    assert "--remote-control" not in out


def test_render_remote_control_stacked_keeps_base_and_flag():
    """観点: stacked タスクでも --base と --remote-control が両立し、name→prompt の順序が保たれる。"""
    plan = mk([
        {"id": "S1", "branch": "s1", "prompt": "p1"},
        {"id": "S2", "branch": "s2", "depends_on": ["S1"], "prompt": "p2"},
    ])
    out = render(plan, analyze(plan), Launch(remote_control=True))
    assert "wt switch --create s2 --base s1 -x claude -- --remote-control s2 p2" in out


def test_render_errors_skips_commands():
    """観点: 致命的エラーがあるとき render はコマンド列を出さず ERROR のみ提示する（誤った計画を実行させない）。"""
    plan = mk([{"id": "A", "branch": "a", "depends_on": ["X"]}])
    out = render(plan, analyze(plan))
    assert "ERROR" in out
    assert "COMMANDS" not in out  # 致命的エラー時はコマンドを出さない


# ---- launch options (model / permission-mode / effort) ----

def test_parse_spec_reads_launch_fields():
    """観点: task の model/permission_mode/effort を parse_spec が読み取り、未指定は空文字になる。"""
    plan = mk([
        {"id": "A", "branch": "a", "model": "opus", "permission_mode": "plan", "effort": "high"},
        {"id": "B", "branch": "b"},
    ])
    assert (plan.tasks[0].model, plan.tasks[0].permission_mode, plan.tasks[0].effort) == (
        "opus", "plan", "high")
    assert (plan.tasks[1].model, plan.tasks[1].permission_mode, plan.tasks[1].effort) == ("", "", "")


def test_launch_flags_global_defaults():
    """観点: task が未指定ならグローバル既定（Launch）の値でフラグ列が組まれる。"""
    plan = mk([{"id": "A", "branch": "a", "prompt": "p"}])
    flags = launch_flags(plan.tasks[0], Launch(model="sonnet", permission_mode="auto", effort="low"))
    assert flags == ["--model", "sonnet", "--permission-mode", "auto", "--effort", "low"]


def test_launch_flags_task_overrides_global():
    """観点: task 個別指定がグローバル既定より優先される（task > Launch）。"""
    plan = mk([{"id": "A", "branch": "a", "model": "opus", "effort": "max"}])
    flags = launch_flags(plan.tasks[0], Launch(model="sonnet", permission_mode="plan", effort="low"))
    # model/effort は task 値、permission_mode は task 未指定なのでグローバル値
    assert flags == ["--model", "opus", "--permission-mode", "plan", "--effort", "max"]


def test_launch_flags_none_when_unset():
    """観点: task もグローバルも未指定なら flag を一切出さない（claude のデフォルトに委ねる）。"""
    plan = mk([{"id": "A", "branch": "a"}])
    assert launch_flags(plan.tasks[0], Launch()) == []


def test_render_injects_launch_flags_before_prompt():
    """観点: 起動フラグが -x claude -- 以降・prompt より前に並び、remote-control とも共存する。

    prompt に空白があると inner 全体の shlex.quote で二重クォートされ突合しにくいので、
    既存テスト同様クォート不要な prompt(pA) で順序（model→effort→remote-control→prompt）を検証する。
    """
    plan = mk([{"id": "A", "branch": "feat-a", "prompt": "pA"}])
    out = render(plan, analyze(plan), Launch(model="opus", effort="high", remote_control=True))
    assert "-x claude -- --model opus --effort high --remote-control feat-a pA" in out


def test_render_launch_note_lists_global_defaults():
    """観点: COMMANDS 見出しにグローバル既定が要約表示され、plan 承認時に何が効くか見える。"""
    plan = mk([{"id": "A", "branch": "a", "prompt": "p"}])
    out = render(plan, analyze(plan), Launch(model="opus", permission_mode="plan", effort="high"))
    assert "起動既定:" in out
    assert "model=opus" in out
    assert "permission-mode=plan" in out
    assert "effort=high" in out


def test_analyze_rejects_bad_permission_mode():
    """観点: task の不正な permission_mode を致命的エラーで弾く（起動時にコケる前に止める）。"""
    plan = mk([{"id": "A", "branch": "a", "permission_mode": "yolo"}])
    an = analyze(plan)
    assert any("permission_mode" in e for e in an.errors)
    assert an.levels == {}


def test_analyze_rejects_bad_effort():
    """観点: task の不正な effort を致命的エラーで弾く。"""
    plan = mk([{"id": "A", "branch": "a", "effort": "ultra"}])
    an = analyze(plan)
    assert any("effort" in e for e in an.errors)


def test_analyze_accepts_valid_launch_fields():
    """観点: 妥当な model/permission_mode/effort は素通し（誤検出しない）。model は自由入力で検証しない。"""
    plan = mk([{"id": "A", "branch": "a", "model": "some-custom-model", "permission_mode": "acceptEdits", "effort": "xhigh"}])
    an = analyze(plan)
    assert an.errors == []
