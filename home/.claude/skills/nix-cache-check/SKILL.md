---
name: nix-cache-check
description: Nix パッケージがバイナリキャッシュから降ってこずローカルビルドになる原因を調査する。
disable-model-invocation: true
argument-hint: "<flake installable または パッケージ名> [--channel <channel>] [--arch <system>]"
---

# nix-cache-check — バイナリキャッシュ未ヒット・Hydraビルド状況の調査

## 背景

`nixos-rebuild switch` や `home-manager switch`、`nix build` で特定パッケージだけがキャッシュから来ずローカルビルドになるとき、原因は主に3系統に分かれる。**闇雲に `nix build -L` でログを眺める前に、まずどの系統かを切り分ける**。

1. **substituters に該当パスが本当に無い** — cache.nixos.org だけでなく、実行環境に設定された cachix 等の substituter も含めて確認する必要がある
2. **Hydra 側でまだビルドが完了/成功していない** — 評価(eval)されてからビルドされキャッシュに反映されるまでにラグがあり、失敗すればキャッシュには一生乗らない
3. **手元の flake が評価する derivation が期待と違う** — 同じバージョン文字列でも依存更新で derivation ハッシュ（＝出力パス）が変わることがあり、「ソース上は修正済みのはずなのに直らない」という思い込みの原因になる

決定論的に確認できる部分（実出力パスの評価、narinfo 直接確認、Hydra API 呼び出し、PR 祖先関係の確認）は `scripts/nix-cache-check.sh` に切り出してある。HTML を自前でスクレイピングするのは最終手段（失敗ログの中身を読みたいときの `build-log` サブコマンドのみ）。

## 調査フロー

### 1. 実際に評価される出力パスを確定する

同じバージョン表記でも依存関係が更新されれば derivation ハッシュは変わる。まずこれを確定させないと、以降の cache-check や hydra 比較が的外れになる。

```bash
bash <skill-dir>/scripts/nix-cache-check.sh outpath '.#nixosConfigurations.<host>.pkgs.<package>'
```

`.#homeConfigurations.<name>.pkgs.<package>` や単なる `nixpkgs#<package>` 相当のインストーラブルでも同様に使える。

### 2. substituters に該当パスがあるか直接確認する

`nix path-info --store https://...` はローカルに `.drv` が無いと使えないことがあるため、narinfo を HTTP で直接叩くほうが確実。実行環境の `nix show-config` に登録済みの substituters（cache.nixos.org・cachix 各種）**全部**を自動で対象にする。

```bash
bash <skill-dir>/scripts/nix-cache-check.sh cache-check <出力パスまたは先頭ハッシュ>
```

- `HIT` … そのキャッシュに存在する
- `MISS` … 存在しない（未ビルド or ビルド失敗）
- `NO_ACCESS(401/403)` … private cache の可能性。認証設定を疑う
- 特定の substituter だけ確認したい場合は `cache-check <path> <url> [<url>...]` のように明示指定もできる

全て `MISS` なら、次に Hydra 側の状況を見る。

### 3. Hydra のビルド状況を確認する

**HTML の一覧ページを自前でスクレイピングしない。** nix-community 製の専用ツール `hydra-check`（nixpkgs に `pkgs.hydra-check` として収録済み）をまず使う。

```bash
bash <skill-dir>/scripts/nix-cache-check.sh hydra <package> --channel nixpkgs-unstable --arch x86_64-linux
```

ビルド履歴が成功/失敗/日付付きで一覧表示される。特定の build ID の詳細を正確に見たいときは JSON API を使う（一覧ページのステータスバッジは簡易表示で不正確なことがある）。

```bash
bash <skill-dir>/scripts/nix-cache-check.sh build-json <build-id>
# finished/buildstatus で正確な成否がわかる。buildstatus: 0 = 成功
```

失敗していた場合、失敗ログの末尾は JSON に含まれないため HTML から読む（ここだけスクレイピングが必要な理由がある箇所）:

```bash
bash <skill-dir>/scripts/nix-cache-check.sh build-log <build-id>
```

`build-log` の中身は Python スクリプト（`scripts/hydra_build_log.py`）で、`uv run` 経由（PEP 723 inline metadata で Python バージョンを固定）で実行して再現性を持たせている。`uv` が入っていない環境でも `nix` さえあれば `nix run nixpkgs#uv -- run ...` に自動フォールバックするので、素の `python3` には依存しない。

### 4. 特定の修正（PR）が現在ロックしている revision に含まれるか確認する

「この不具合、nixpkgs の PR #xxxxx で直ってるはずでは?」を確認するとき、対象リポジトリを `git clone` するのは重すぎる（特に nixpkgs）。GitHub の compare API で祖先関係だけ確認する。

```bash
gh api repos/NixOS/nixpkgs/pulls/<PR番号> --jq '{merged, merge_commit_sha, merged_at}'
bash <skill-dir>/scripts/nix-cache-check.sh pr-ancestry NixOS/nixpkgs <PRのmerge_commit_sha> <flake.lockがロックしているrev>
```

`behind_by: 0` なら base（PRの修正）は head（ロック中の revision）の祖先＝取り込み済み。ここが Yes でも 2. でキャッシュに無いなら、原因は「ソースは直っているが Hydra のビルドがまだ/失敗」であって、こちらの設定側の問題ではない。

## 典型的な結論パターン

- 1と3で出力パスが「期待通り最新」で、2が全 MISS、3(hydra)で該当ビルドが `Queued`/`Failed` → **Hydra側の一時的な遅延・インフラ障害**。設定側に問題はなく、ローカルビルドを許容するか `nix flake update` でさらに新しい revision（既にキャッシュ済みの可能性がある）に進めるか判断する
- 同じバージョン文字列なのに 1 で出力パスが以前と変わっている → **依存関係の更新で derivation が変わった**。過去の調査結果（別ハッシュ）をそのまま使い回さない
- `NO_ACCESS` が出る substituter がある → private cache。認証トークン設定（`netrc` や `nix.conf` の `access-tokens`）を確認する

## 制約・前提

- `nix`（flakes 有効）、`curl`、`jq` が必要。`gh` は pr-ancestry のみで使用（要 `gh auth login`）
- `hydra-check` はサブコマンド内で自動的に `nix run nixpkgs#hydra-check --` にフォールバックするが、頻用するなら `pkgs.hydra-check` を環境に入れておくと速い
- Hydra への問い合わせは 1 リクエストあたり数秒かかることがある。大量のパッケージを一括チェックするような使い方はしない（Hydra は他にも大事な仕事をしている）
- narinfo の直接確認は認証不要な public cache が前提。private cache の実在確認には別途トークンが要ることがある
