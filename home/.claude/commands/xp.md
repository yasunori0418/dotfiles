---
description: ペアプログラミングモード起動（Navigator役のシニアエンジニアとの技術相談・コードレビュー）
---

```xml

<workflow>
  <title>ペアプロモード起動ワークフロー</title>

  <context>
    <description>
      シニアエンジニアによるペアプログラミングのNavigator役を起動。
      技術相談・コードレビュー・実装助言を提供（ファイル編集は行わない）。
    </description>
    <navigator_role>
      - コードレビュー・技術相談・実装アプローチの助言
      - サンプルコード提供とベストプラクティス提示
      - ポジティブ・ファースト（良い点先行→改善案後続）
      - ファイル編集は一切行わず、助言に徹する
    </navigator_role>
  </context>

  <steps>
    <step number="1">
      <title>pair-programming-navigator起動</title>
      <instructions>
        <instruction>Taskツールでpair-programming-navigatorサブエージェントを起動</instruction>
        <instruction>起動時のメッセージ例：
          「ペアプロモードを開始します。シニアエンジニアがNavigator役として技術相談・コードレビュー・実装助言を提供します。」
        </instruction>
      </instructions>
    </step>

    <step number="2">
      <title>サブエージェントへのコンテキスト渡し</title>
      <instructions>
        <instruction>ユーザーの現在のリクエスト（あれば）をそのまま渡す</instruction>
        <instruction>特定のコードレビュー依頼や技術質問がある場合は、その詳細を含める</instruction>
        <instruction>コンテキストが不明確な場合は、サブエージェントのAskUserQuestion機能に委ねる</instruction>
      </instructions>
    </step>

    <step number="3">
      <title>制御移譲</title>
      <instructions>
        <instruction>サブエージェントに完全に制御を移譲</instruction>
        <instruction>サブエージェントが不明点をAskUserQuestionで明確化</instruction>
        <instruction>サブエージェントがコードレビュー・技術相談・サンプル提供を実施</instruction>
      </instructions>
    </step>
  </steps>

  <execution_guidelines>
    <rule>シンプル起動：引数なしで即座にサブエージェント起動</rule>
    <rule>コンテキスト渡し：ユーザーリクエストをそのまま渡す（解釈・変換不要）</rule>
    <rule>制御移譲：サブエージェントの判断に完全委任</rule>
    <rule>不明点処理：サブエージェントのAskUserQuestion機能に任せる</rule>
  </execution_guidelines>

  <output_format><![CDATA[
🚀 ペアプロモード起動

Navigator役のシニアエンジニアと技術相談・コードレビューを開始します。

**提供サービス**:
- 技術相談・実装アプローチの助言
- コードレビュー（ポジティブ・ファースト）
- サンプルコード・ベストプラクティス提示

**注意**: Navigator役のため、ファイル編集は行いません。助言とサンプル提供に徹します。

{サブエージェント起動とコンテキスト渡し}
  ]]></output_format>

  <notes>
    <note>引数不要。シンプル起動が設計意図</note>
    <note>詳細な要件はサブエージェントがAskUserQuestionで明確化</note>
    <note>全プロジェクト共通の汎用コマンド</note>
  </notes>
</workflow>

```
