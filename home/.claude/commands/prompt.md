---
description: プロンプト改善
argument-hint: prompt [改善したいプロンプト]
---

```xml

<!-- ⚠️ GUARD RAIL: プロンプト改善のみ実行。改善結果の自動実行禁止 -->

<guard_rail>
  <rule id="purpose_only">
    <description>プロンプト改善のみを実行。改善後のプロンプトで自動実行禁止</description>
    <constraints>
      <item>$ARGUMENTS は改善対象のプロンプト（実行対象ではない）</item>
      <item>改善結果をユーザーに提示したら処理終了</item>
      <item>ユーザーの明示指示まで待機</item>
    </constraints>
  </rule>

  <rule id="claude_directory">
    <description>.claude/**ファイルの場合、ユーザー意図を確認してから修正</description>
    <constraints>
      <item>ファイル全体を改善対象か、特定セクションか確認</item>
      <item>修正後、全体の動作整合性を検証</item>
      <item>単なる文字列置換ではなく、意味的整合性を保つ</item>
    </constraints>
  </rule>
</guard_rail>

<workflow>
  <title>プロンプト改善ワークフロー</title>

  <roles>
    <main>分析 → Sub Agent呼び出し → 検証 → ユーザー報告</main>
    <sub_agent name="prompt-optimizer">Claude Codeプロンプトをベストプラクティスに基づいて最適化</sub_agent>
  </roles>

  <context>
    <user_request>
      <description>ユーザーから渡された改善前のプロンプト</description>
      <content>$ARGUMENTS</content>
    </user_request>

    <guidelines>
      <item>明確で直接的な指示、XML構造化、Chain of Thought適用</item>
      <item>多例示（3-5個）、出力形式・検証基準の明確化</item>
      <item>Claude Code利用可能ツール（Edit, Grep, Bash等）を考慮</item>
    </guidelines>
  </context>

  <steps>
    <step number="1">
      <title>初期分析とユーザー確認</title>
      <instructions>
        <instruction>プロジェクトコンテキスト（CLAUDE.md）を確認</instruction>
        <instruction>.claude/**ファイル検出時：ファイル内容読み込み → 改善対象箇所をユーザーに確認</instruction>
        <instruction>曖昧な点を分析：目的/範囲・出力形式・制約・成功基準</instruction>
        <instruction>AskUserQuestionで確認（2-4選択肢、最大4質問）</instruction>
      </instructions>
      <success>意図・範囲・制約・出力が明確化</success>
      <error_handling>
        <item condition="ユーザー無応答">最一般的解釈で進行（その旨明記）</item>
        <item condition=".claude/**ファイル">改善箇所を具体化（セクション/ルール単位で確認）</item>
      </error_handling>
    </step>

    <step number="2">
      <title>Sub Agent呼び出しと監視</title>
      <instructions>
        <instruction>Sub Agent `prompt-optimizer`を呼び出し（テンプレート参照）</instruction>
        <instruction>出力を検証基準で評価 → 問題あれば改善方向を指示して再依頼（最大3反復）</instruction>
      </instructions>
      <sub_agent_prompt_template>
        <context>
          <original_prompt>$ARGUMENTS</original_prompt>
          <step1_clarification>Step 1で収集したQ&amp;Aと意図確認結果</step1_clarification>
          <project_context>CLAUDE.md関連情報（技術スタック・特記事項）</project_context>
        </context>
        <task>
          <role>プロンプトエンジニアリング専門家として、Claude Codeが効果的に作業できるプロンプトに改善してください</role>
          <requirements>
            <item>明確で具体的、XMLで構造化</item>
            <item>複雑タスク時は&lt;thinking&gt;タグでChain of Thoughtを指示</item>
            <item>3-5個の多様な例を含める</item>
            <item>出力形式・成功基準・検証基準を明確化</item>
            <item>Claude Code利用可能ツール（Edit, Grep, Bash等）を考慮</item>
            <item>ユーザーの元の意図を保持</item>
          </requirements>
          <output>改善済みプロンプト + 改善点の説明</output>
        </task>
      </sub_agent_prompt_template>
      <validation>XML構造・明確性・完全性・ベストプラクティス適用・ツール互換性・意図保持</validation>
      <error_handling>
        <item>Sub Agent無応答 → 再試行（最大2回）</item>
        <item>逸脱 → ユーザー確認</item>
      </error_handling>
    </step>

    <step number="3">
      <title>最終検証とユーザー報告</title>
      <instructions>
        <instruction>最終チェック：意図保持・実行可能性・明確性・XML構造・ベストプラクティス準拠</instruction>
        <instruction>出力形式に基づきユーザーに報告</instruction>
        <instruction>処理終了 → ユーザー新指示まで待機（自動実行禁止）</instruction>
      </instructions>
      <output_format><![CDATA[
# プロンプト改善結果

## 改善前
{$ARGUMENTS}

## 改善後
{改善済みプロンプト}

---

## 主な改善点
- {改善カテゴリと説明} × 3-5個

## 推奨事項
- {効果的な使用方法とベストプラクティス}
      ]]></output_format>
    </step>
  </steps>

  <execution_guidelines>
    <priorities>
      <item rank="1">ユーザーの元の意図を保持</item>
      <item rank="2">Claude Code環境での実行可能性</item>
      <item rank="3">ベストプラクティス準拠</item>
      <item rank="4">簡潔さ ↔ 完全性のバランス</item>
    </priorities>
    <decision_rules>
      <rule>複数案がある → より明確で具体的な方を選択</rule>
      <rule>シンプルな構造を優先</rule>
      <rule>Claude Codeツール活用を考慮</rule>
    </decision_rules>
  </execution_guidelines>

  <notes>
    <note>反復的ワークフロー。完璧より実用的改善を優先</note>
    <note>Sub Agent要求は控えめに。3反復で最善を採用</note>
    <note>ユーザー依頼から逸脱しないか常に確認</note>
    <note priority="critical">⚠️ 役割：プロンプト改善のみ。自動実行禁止。ユーザー新指示まで待機</note>
  </notes>
</workflow>

```
