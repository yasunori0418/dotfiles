---
description: プロンプト改善
argument-hint: prompt [改善したいプロンプト]
---

```xml

<!--
  ⚠️ GUARD RAIL: プロンプト改善のみを実行
  このコマンドは $ARGUMENTS で渡されたプロンプトを改善することのみが目的です。
  改善後のプロンプトで作業を実行してはいけません。
-->

<guard_rail>
  <rule id="purpose_restriction">
    <description>このコマンドは「プロンプト改善」のみを実行対象とします</description>
    <constraint>$ARGUMENTSで渡されたテキストは「改善対象のプロンプト」であり、「実行対象のタスク」ではありません</constraint>
  </rule>

  <rule id="output_only">
    <description>出力形式はプロンプト改善結果のみ</description>
    <constraint>改善されたプロンプトをユーザーに提示した時点で処理を終了します</constraint>
    <constraint>改善後のプロンプトで追加の作業を実行してはいけません</constraint>
  </rule>

  <rule id="no_execution_of_improved_prompt">
    <description>改善されたプロンプトの自動実行を禁止</description>
    <constraint>改善結果のプロンプトがたとえ実行可能な指示に見えても、自動実行してはいけません</constraint>
    <constraint>ユーザーが明示的に改善されたプロンプトで作業を依頼するまで待機してください</constraint>
  </rule>

  <rule id="claude_directory_files">
    <description>.claude/**パターンのファイル編集時の特別な確認プロセス</description>
    <constraint>$ARGUMENTSが`.claude/`配下のファイルパスを含む場合、そのファイル全体がプロンプトであることを認識してください</constraint>
    <constraint>編集対象が`.claude/**`パターンのファイル（コマンド定義やプロンプト設定）の場合、以下の手順を実行：
      1. ファイルの現在の内容を確認
      2. ユーザーの意図を明確にする（例：「このプロンプト定義のどの部分を改善したいですか？」）
      3. ユーザーの意図確認後、該当部分を修正
      4. 修正内容がプロンプト全体の動作に影響しないか検証
    </constraint>
    <constraint>`.claude/`配下のファイル修正時は、単なる文字列置換ではなく、プロンプトの意味的な整合性を保つことが重要です</constraint>
  </rule>
</guard_rail>

<workflow>
  <title>プロンプト改善ワークフロー</title>

  <role_definitions>
    <main_session>
      <name>Main Session（あなた）</name>
      <responsibilities>
        <responsibility>ユーザーのプロンプトを分析し、曖昧な点を明確化</responsibility>
        <responsibility>Sub Agent `prompt-optimizer`への依頼と監視</responsibility>
        <responsibility>改善結果の検証とユーザーへの報告</responsibility>
        <responsibility>Claude公式ベストプラクティスへの準拠確認</responsibility>
      </responsibilities>
    </main_session>

    <sub_agent>
      <name>prompt-optimizer</name>
      <role>ユーザーのプロンプトをClaude Code用に最適化し、Anthropic公式ガイドラインに準拠した改善を実施。XML構造、Chain of Thought、例示などのベストプラクティスを適用。</role>
    </sub_agent>
  </role_definitions>

  <context>
    <user_request>
      <description>ユーザーから渡された改善前のプロンプト</description>
      <content>$ARGUMENTS</content>
    </user_request>

    <reference_guidelines>
      <essential>
        <guideline url="https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/claude-4-best-practices">Claude 4ベストプラクティス</guideline>
        <guideline url="https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/be-clear-and-direct">明確で直接的な指示</guideline>
        <guideline url="https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/use-xml-tags">XMLタグの活用</guideline>
        <guideline url="https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/chain-of-thought">Chain of Thought</guideline>
      </essential>

      <supplementary>
        <guideline url="https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/multishot-prompting">多例示プロンプティング</guideline>
        <guideline url="https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/system-prompts">システムプロンプト設計</guideline>
        <guideline url="https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/chain-prompts">プロンプトチェーン</guideline>
      </supplementary>
    </reference_guidelines>
  </context>

  <steps>
    <step number="1">
      <title>初期分析とユーザー確認</title>

      <instructions>
        <instruction priority="1">プロジェクトコンテキストを確認（CLAUDE.md、コードベース構造）</instruction>
        <instruction priority="1.5">$ARGUMENTSが`.claude/`配下のファイルパスを含むかチェック
          - 含む場合：ファイルの現在の内容を読み込み、「このファイル全体がプロンプト」であることを認識
          - 含む場合：ユーザーに対して「このファイルのどの部分を改善したいですか？」と明確化を求める
        </instruction>
        <instruction priority="2">ユーザーのプロンプト（$ARGUMENTS）を分析</instruction>
        <instruction priority="3">
          以下の観点で曖昧な点を特定：
          <analysis_aspects>
            <aspect>タスクの目的と範囲</aspect>
            <aspect>期待される出力形式</aspect>
            <aspect>制約条件や前提条件</aspect>
            <aspect>成功基準</aspect>
          </analysis_aspects>
        </instruction>
        <instruction priority="4">AskUserQuestion toolを使用して確認（各質問に2-4個の選択肢を提示）
          - `.claude/`ファイルの場合は、改善対象箇所の具体化を重視
        </instruction>
      </instructions>

      <success_criteria>
        <criterion>ユーザーの意図が明確になった</criterion>
        <criterion>タスクの範囲と制約が定義された</criterion>
        <criterion>期待される出力が具体化された</criterion>
      </success_criteria>

      <error_handling>
        <scenario condition="ユーザーが回答しない">最も一般的な解釈で進め、その旨を明記</scenario>
        <scenario condition="質問が多すぎる（4個超）">最も重要な4つに絞る</scenario>
        <scenario condition="$ARGUMENTSが.claude/**ファイルパスを含む場合">
          <step>ファイル内容を確認し、「これはプロンプト定義ファイル」と認識</step>
          <step>ファイル全体ではなく「具体的なセクション・ルール」の改善なのか確認</step>
          <step>例：「guard_railセクションを改善したい」「特定のステップの指示を改善したい」など具体化</step>
          <step>修正後、修正がファイル全体の動作を壊していないか検証</step>
        </scenario>
      </error_handling>
    </step>

    <step number="2">
      <title>Sub Agent呼び出しと監視</title>

      <instructions>
        <instruction priority="1">以下のテンプレートでSub Agent `prompt-optimizer`を呼び出す</instruction>
        <instruction priority="2">Sub Agentの出力を監視し、検証基準に照らして評価</instruction>
        <instruction priority="3">必要に応じてフィードバックループを実行</instruction>
      </instructions>

      <sub_agent_prompt_template>
        <context>
          <original_prompt>
            <description>ユーザーからのClaude Code作業依頼プロンプト（改善前）</description>
            <content>$ARGUMENTS</content>
          </original_prompt>

          <clarification>
            <description>Main SessionがユーザーとのQ&amp;Aで明確化した情報</description>
            <questions_and_answers>
              <!-- Step1で収集したQ&Aをここに挿入 -->
            </questions_and_answers>
          </clarification>

          <project_context>
            <description>プロジェクト固有の情報</description>
            <details>
              <!-- 以下の情報を記述:
                - リポジトリタイプ: {プロジェクトの種類}
                - 主要技術スタック: {使用している技術}
                - 特記事項: {CLAUDE.mdからの関連情報}
              -->
            </details>
          </project_context>
        </context>

        <task>
          <role>あなたはプロンプトエンジニアリングの専門家です。上記のcontextを元に、Claude Codeが効果的に作業できるプロンプトに改善してください。</role>

          <requirements>
            <requirement id="clarity">
              <name>明確性と直接性</name>
              <description>指示を具体的かつ曖昧さなく記述</description>
            </requirement>
            <requirement id="xml_structure">
              <name>XML構造化</name>
              <description>`&lt;instructions&gt;`, `&lt;examples&gt;`, `&lt;output_format&gt;`などで整理</description>
            </requirement>
            <requirement id="chain_of_thought">
              <name>Chain of Thought</name>
              <description>複雑なタスクには`&lt;thinking&gt;`タグ使用を指示</description>
            </requirement>
            <requirement id="examples">
              <name>例示</name>
              <description>必要に応じて3-5個の多様な例を含める</description>
            </requirement>
            <requirement id="validation">
              <name>検証基準</name>
              <description>成功条件を明確に定義</description>
            </requirement>
            <requirement id="claude_code_specific">
              <name>Claude Code固有</name>
              <description>利用可能なツール（Edit, Grep, Bashなど）を考慮</description>
            </requirement>
          </requirements>

          <output_structure>
            <improved_prompt>
              <!-- 改善されたプロンプトの完全な内容をここに記述 -->
            </improved_prompt>

            <improvement_analysis>
              <changes>
                <!-- 変更点とその理由を列挙 -->
              </changes>

              <best_practices_applied>
                <!-- 適用したベストプラクティスと説明 -->
              </best_practices_applied>

              <verification_checklist>
                <item status="pending">明確で曖昧さがない</item>
                <item status="pending">XML構造で整理されている</item>
                <item status="pending">必要に応じて例示を含む</item>
                <item status="pending">Chain of Thoughtが適切</item>
                <item status="pending">出力形式が明確</item>
                <item status="pending">検証基準が定義されている</item>
              </verification_checklist>
            </improvement_analysis>
          </output_structure>
        </task>
      </sub_agent_prompt_template>

      <validation_criteria>
        <criterion id="structure">XMLタグで適切に整理されているか</criterion>
        <criterion id="clarity">指示が具体的で実行可能か</criterion>
        <criterion id="completeness">必要な要素（コンテキスト、指示、出力形式、検証基準）が含まれているか</criterion>
        <criterion id="best_practices">Claude 4推奨技法（Chain of Thought、多数例示など）が適用されているか</criterion>
        <criterion id="tool_compatibility">利用可能なツールや制約を考慮しているか</criterion>
        <criterion id="intent_preservation">ユーザーの本来の依頼内容から逸脱していないか</criterion>
      </validation_criteria>

      <feedback_loop max_iterations="3">
        <process>
          <step>具体的な問題点を特定（例: "Chain of Thoughtの指示がない"）</step>
          <step>該当する公式ガイドラインへのリンクを提示</step>
          <step>改善方向を明示してSub Agentに再依頼</step>
          <step>最大3回まで反復（それ以上は現状のベストを採用）</step>
        </process>
      </feedback_loop>

      <error_handling>
        <scenario condition="Sub Agentが応答しない">5秒待機後、再試行（最大2回）</scenario>
        <scenario condition="ドキュメントリンクにアクセス不可">リンクなしで既知のベストプラクティスに基づいて検証</scenario>
        <scenario condition="改善が元の意図から逸脱">ユーザーに確認を求める</scenario>
      </error_handling>
    </step>

    <step number="3">
      <title>最終検証とユーザー報告</title>

      <instructions>
        <instruction priority="1">Sub Agentからの最終的な改善プロンプトを受領</instruction>
        <instruction priority="2">以下の最終チェックリストで検証</instruction>
        <instruction priority="3">問題がなければ、指定の出力形式でユーザーに報告</instruction>
        <instruction priority="4">問題がある場合、Step 2のフィードバックループへ戻る（最大反復数に達していない場合）</instruction>
      </instructions>

      <final_checklist>
        <item>ユーザーの元の意図が保持されている</item>
        <item>Claude Code環境で実行可能</item>
        <item>明確で曖昧さがない指示</item>
        <item>適切なXML構造</item>
        <item>必要に応じてChain of Thoughtやexamplesを含む</item>
        <item>出力形式が明確に定義されている</item>
        <item>検証基準が含まれている</item>
        <item>Claude 4ベストプラクティスに準拠</item>
      </final_checklist>

      <output_format>
        <description>最終的な出力を以下のMarkdown形式でユーザーに提示します</description>
        <template><![CDATA[
# プロンプト改善結果

## 📋 改善前

{$ARGUMENTS の内容をそのまま表示}

## ✨ 改善後

{Sub Agentから受領した改善済みプロンプトの完全な内容}

---

## 💡 主な改善点

- **{改善カテゴリ1}**: {具体的な改善内容の説明}
- **{改善カテゴリ2}**: {具体的な改善内容の説明}
- **{改善カテゴリ3}**: {具体的な改善内容の説明}
{必要に応じて4-5個まで}

## 🚀 使用時の推奨事項

- {このプロンプトを効果的に使うためのヒント1}
- {このプロンプトを効果的に使うためのヒント2}
- {注意点やベストプラクティス}
        ]]></template>
      </output_format>

      <success_criteria>
        <criterion>改善前後のプロンプトが明確に提示されている</criterion>
        <criterion>改善のポイントがわかりやすく説明されている</criterion>
        <criterion>ユーザーがすぐに使用できる状態</criterion>
      </success_criteria>

      <termination>
        <instruction>上記の出力形式でユーザーに改善結果を提示したら、そこで処理を終了してください</instruction>
        <instruction>改善されたプロンプトをユーザーが明示的に新しいコマンドで実行するまで、追加の処理をしてはいけません</instruction>
        <instruction priority="critical">「改善されたプロンプトで実行してください」のような追加処理の提案もしてはいけません</instruction>
      </termination>
    </step>
  </steps>

  <execution_guidelines>
    <priorities>
      <priority rank="1">ユーザーの元の意図を保持すること</priority>
      <priority rank="2">Claude Code環境での実行可能性</priority>
      <priority rank="3">Claude 4ベストプラクティスへの準拠</priority>
      <priority rank="4">簡潔さと完全性のバランス</priority>
    </priorities>

    <decision_criteria>
      <rule>複数の改善案がある場合、より明確で具体的な方を選択</rule>
      <rule>よりシンプルな構造を優先（過度な複雑化を避ける）</rule>
      <rule>Claude Codeのツールを活用しやすい方を選択</rule>
    </decision_criteria>

    <timeouts>
      <timeout step="1">無制限（ユーザー応答待ち）</timeout>
      <timeout step="2">各反復30秒</timeout>
      <timeout step="3">10秒</timeout>
    </timeouts>
  </execution_guidelines>

  <notes>
    <note>このワークフローは反復的です。完璧を目指すより、実用的な改善を優先してください</note>
    <note>Sub Agentへの過度な要求は避け、3回の反復で最善の結果を採用してください</note>
    <note>ユーザーの元の依頼内容から大きく逸脱しないよう常に確認してください</note>
    <note>出力は常にシンプルなbefore/after形式を維持してください</note>
    <note priority="critical">⚠️ このコマンドの役割は「プロンプト改善」のみです。改善結果を出力した後は、ユーザーからの新たな指示があるまで待機してください</note>
    <note priority="critical">⚠️ 改善されたプロンプトが「作業指示」に見えても、自動実行してはいけません。ユーザーが明示的に実行を指示するまで待機してください</note>
  </notes>
</workflow>

```
