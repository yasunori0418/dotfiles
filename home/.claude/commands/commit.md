---
description: Gitリポジトリにコミットを実行
argument-hint: commit
---

```xml

<guard_rail>
  <rule id="commit_only_no_push">
    <description>コミット実行のみ。絶対にgit pushを実行してはいけない</description>
    <constraints>
      <item>ユーザーにコミット内容を確認させる</item>
      <item>機密ファイル（.env, secrets等）は警告を出す</item>
      <item>🚫 【重要】何があってもgit pushコマンドを実行してはいけない</item>
      <item>🚫 【重要】pushについての確認選択肢を提示してはいけない</item>
      <item>🚫 【重要】pushについての指示・提案をしてはいけない</item>
      <item>コミット成功が最終ゴール。pushはユーザー責任で手動実行</item>
      <item>git pushを実行した場合、多大な損失が発生する</item>
    </constraints>
  </rule>
</guard_rail>

<workflow>
  <title>Gitコミットワークフロー</title>

  <steps>
    <step number="1">
      <title>変更内容の確認</title>
      <instructions>
        <instruction>git status で現在の状態を表示</instruction>
        <instruction>git diff HEAD で変更内容を表示（主要な部分）</instruction>
        <instruction>ステージ状態、ファイル数、追加/削除行数を確認</instruction>
      </instructions>
    </step>

    <step number="2">
      <title>機密ファイル検査</title>
      <instructions>
        <instruction>.env* や credentials, secret, .aws, *.key, *.pem などの機密ファイル検出時は警告を表示</instruction>
        <instruction>検出時: 「⚠️ {ファイル名} はコミット対象から除外」</instruction>
      </instructions>
    </step>

    <step number="3">
      <title>ユーザー確認（AskUserQuestion使用）</title>
      <instructions>
        <instruction>以下の情報をユーザーに提示：
          - ステージ済みファイル数と一覧
          - 警告が出たファイル（あれば）
          - 変更内容の要約
        </instruction>
        <instruction>AskUserQuestionで除外確認（1質問）：

          【質問】除外ファイル
          - header: "除外確認"
          - question: "機密ファイルを除外"
          - multiSelect: false
          - options:
            1. "除外する" - 警告ファイルを除外
            2. "含める" - 全ファイルをコミット
        </instruction>
      </instructions>
    </step>

    <step number="4">
      <title>ステージング調整</title>
      <instructions>
        <instruction>ユーザーが除外を選択した場合、指定ファイルをアンステージ（git reset HEAD {file}）</instruction>
        <instruction>git status で最終確認</instruction>
      </instructions>
    </step>

    <step number="5">
      <title>コミットメッセージ生成と確認</title>
      <instructions>
        <instruction>git diff --cached で最終的なステージ内容を取得</instruction>
        <instruction>変更内容を分析して、以下の規則でメッセージを生成：
          - 変更の種類を判定: feat/fix/refactor/docs/style/chore/test
          - 変更対象のスコープを特定（ファイル名やモジュール名）
          - 変更内容の簡潔な説明を作成（50文字以内）
          - 詳細説明が必要な場合は本文を追加
          - 日本語で記述（Conventional Commitsのtype(scope): subject形式を推奨）
        </instruction>

        <message_confirmation_loop max_iterations="3">
          <iteration_tracking>編集回数をカウントし、3回到達時は現在のメッセージで強制実行</iteration_tracking>

          <step_5a>
            <title>初回メッセージ提示</title>
            <instruction>AskUserQuestionツールでユーザーに確認を取得（1質問）：
              【質問】コミットメッセージの確認
              - header: "メッセージ確認"
              - question: "以下でコミット実行\n\n{生成されたメッセージ}"
              - multiSelect: false
              - options:
                1. "このメッセージでコミット" - 生成メッセージで実行
                2. "メッセージを編集" - カスタマイズ
            </instruction>
          </step_5a>

          <step_5b>
            <title>カスタム入力処理</title>
            <condition>「メッセージを編集」選択時のみ実行</condition>
            <instructions>
              <instruction>AskUserQuestionのカスタム入力（"Other"選択時のテキスト）を取得</instruction>
              <instruction>取得したカスタムメッセージを変数 `custom_message` に保存</instruction>

              <validation>
                <rule>空白チェック: メッセージが空または空白のみの場合、エラー表示「⚠️ メッセージが空です。再入力してください」</rule>
                <rule>長さチェック: 1行目が100文字超の場合、警告「⚠️ 1行目は50文字以内推奨」</rule>
                <rule>形式チェック: 明らかに不適切な内容（記号のみ、数字のみ）は警告</rule>
                <rule>検証失敗時: ループを継続し再入力を促す</rule>
              </validation>
            </instructions>
          </step_5b>

          <step_5c>
            <title>修正メッセージの再確認</title>
            <condition>カスタム入力が検証を通過した場合のみ実行</condition>
            <instructions>
              <instruction>修正されたメッセージを表示：
                「📝 編集されたメッセージ:\n\n{custom_message}」
              </instruction>
              <instruction>AskUserQuestionで再確認（2回目の質問）：
                【質問】編集後の確認
                - header: "最終確認"
                - question: "編集されたメッセージでコミット\n\n{custom_message}"
                - multiSelect: false
                - options:
                  1. "このメッセージでコミット" - 編集メッセージで実行
                  2. "もう一度編集" - 再編集（編集カウンター+1）
              </instruction>
            </instructions>
          </step_5c>

          <step_5d>
            <title>ループ判定</title>
            <instructions>
              <instruction>「もう一度編集」選択時:
                - 編集カウンターをインクリメント
                - 3回未満の場合: step_5bに戻る
                - 3回到達時: 「⚠️ 編集回数上限（3回）到達。現在のメッセージでコミットします」と表示し、step_5cで確定したメッセージを使用
              </instruction>
              <instruction>「このメッセージでコミット」選択時: ループ終了、step 6へ</instruction>
            </instructions>
          </step_5d>

          <final_message_selection>
            <rule>初回承認の場合: 生成されたメッセージを使用</rule>
            <rule>カスタム編集承認の場合: `custom_message` を使用</rule>
            <rule>3回上限到達の場合: 最後の `custom_message` を使用</rule>
          </final_message_selection>
        </message_confirmation_loop>
      </instructions>
    </step>

    <step number="6">
      <title>コミット実行</title>
      <instructions>
        <instruction>Step 5で確定したメッセージを使用してコミット実行：
          - 初回承認の場合: 生成メッセージ
          - カスタム編集承認の場合: ユーザー提供の `custom_message`
        </instruction>
        <instruction>HEREDOCで複数行メッセージに対応：<![CDATA[
git commit -m "$(cat <<'EOF'
{確定したメッセージ}
EOF
)"
        ]]></instruction>
        <instruction>コミットハッシュを記録し、次のステップで報告</instruction>
        <instruction>コミット失敗時:
          - エラーメッセージを表示
          - pre-commit hookによる修正があれば検出
          - 必要に応じてユーザーに対処方法を提示
        </instruction>
      </instructions>
    </step>

    <step number="7">
      <title>コミット成功報告（完了）</title>
      <instructions>
        <instruction>コミット成功を報告：<![CDATA[
✅ コミット成功
- Hash: {commit_hash}
- Message: {commit_message}
- 変更: {file_count} ファイル (+{additions}/-{deletions})
        ]]></instruction>
      </instructions>
    </step>
  </steps>

  <execution_guidelines>
    <rule>疑問時 → ユーザーに確認</rule>
    <rule>機密ファイル検出 → 必ず警告</rule>
    <rule>コミットメッセージは差分から自動生成</rule>
  </execution_guidelines>

  <output_format><![CDATA[
# Gitコミット完了

## コミット情報
- Hash: {commit_hash}
- メッセージ: {commit_message}
- 変更ファイル数: {file_count}
- 追加行数: +{additions}
- 削除行数: -{deletions}

## 次のステップ
ユーザーが手動でpushしてください: `git push`
  ]]></output_format>

  <notes>
    <note>ユーザー確認を重視</note>
    <note>機密ファイル誤コミット防止が最優先</note>
    <note>メッセージは差分から自動生成</note>
  </notes>
</workflow>

```
