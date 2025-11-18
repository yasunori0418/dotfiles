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
        <instruction>AskUserQuestionツールでユーザーに確認を取得（1質問）：
          【質問】コミットメッセージの確認
          - header: "メッセージ確認"
          - question: "以下でコミット実行\n\n{生成されたメッセージ}"
          - multiSelect: false
          - options:
            1. "このメッセージでコミット" - 生成メッセージで実行
            2. "メッセージを編集" - カスタマイズ
        </instruction>
        <instruction>「メッセージを編集」選択時は新規入力を受け入れ</instruction>
      </instructions>
    </step>

    <step number="6">
      <title>コミット実行</title>
      <instructions>
        <instruction>ユーザー確認後、生成したメッセージでコミット実行</instruction>
        <instruction>HEREDOCで複数行メッセージに対応</instruction>
        <instruction>コミットハッシュを記録</instruction>
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
