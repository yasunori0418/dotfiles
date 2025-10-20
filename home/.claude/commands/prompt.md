---
description: プロンプト改善
argument-hint: prompt [改善したいプロンプト]
---

## ロール: Main Session

あなたは`Main Session`であり、sub agentの`prompt-optimizer`にユーザーから渡されたプロンプトをclaude-codeにおいて効果的なプロンプトに改善する作業を全力で実施するように依頼せよ。
`Main Session`のあなたは、元の依頼内容とは違うプロンプトにならないようにsub agentの作業内容を監視せよ。

### Sub Agentの監視観点

sub agentの`prompt-optimizer`の作業内容を監視する際、以下に提示した各リンクを確認し、それらリンク先の内容に基づいたプロンプトになっているか確認せよ。
sub agentの作業内容によって得られた内容が、以下の内容に基づいていない場合、リンクをsub agentに渡して、継続的なプロンプト改善を依頼せよ。

- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/overview.md
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/claude-4-best-practices
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/prompt-generator
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/prompt-templates-and-variables
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/prompt-improver
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/be-clear-and-direct
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/multishot-prompting
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/chain-of-thought
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/use-xml-tags
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/system-prompts
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/prefill-claudes-response
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/chain-prompts
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/long-context-tips
- @https://docs.claude.com/ja/docs/build-with-claude/prompt-engineering/extended-thinking-tips

## コンテキスト: 元の依頼内容

以下はユーザーから渡された効率的ではない、claude-codeで作業させたいプロンプト。

```text
$ARGUMENTS
```

## Step1: ユーザーからのプロンプトを分析

呼び出されているプロジェクトディレクトリの内容を元に、ユーザーから渡された効率的ではないプロンプトの内容を解析し、不明確な部分があればユーザーに確認せよ。
各質問は2-4つ数字で回答できるレベルの内容にせよ。

## Step2: Sub Agent: `prompt-optimizer`への依頼

Step1で確認した不明各な部分に対するユーザーの回答があった。
`Main Session`であるあなたは、以下のsub agentへ渡すプロンプトから、`context.main-session.question`と`context.main-session.answer`に該当する内容に置き換えて、
sub agentの`prompt-optimizer`を以下のプロンプトで呼び出せ。

### Sub Agent: `prompt-optimizer`へ渡すプロンプト

```xml
<context>
  <prompt>
    <description>
      ユーザーからのclaude-codeに作業依頼するには、非常に非効率的なプロンプト
    </description>
    <body>
      $ARGUMENTS
    </body>
  </prompt>
  <main-session>
    <description>
      ユーザーからのプロンプトを`Main Session`が解析し、元の非常に非効率的なプロンプトに加えて、ユーザーが実施したい作業内容への解像度を上げるための情報
    </description>
    <question>
      `Main Session`からユーザーへの質問
    </question>
    <answer>
      ユーザーが`Main Session`からの質問に回答した内容
    </answer>
  </main-session>
</context>
<request>
  contextの内容を元に、コンテキストエンジニアとして、claude-codeが全力作業を実施するためのプロンプトになるように、全力でプロンプトを改善せよ
</request>
```

## Step3: Sub Agentからの回答確認

`Main Session`であるあなたはsub agentの`prompt-optimizer`から改善されたプロンプトを確認した。
ユーザーに対して、改善後のプロンプトを以下に提示した**出力形式**を元に、作業報告をせよ。

### 出力形式

```markdown
## before

$ARGUMENTS

## after

{改善後のプロンプト}

```
