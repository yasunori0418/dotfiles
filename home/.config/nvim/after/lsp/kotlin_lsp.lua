---@type vim.lsp.Config
return {
    -- cmd = vim.lsp.rpc.connect("127.0.0.1", tonumber(9999)),

    -- ## cmd: string[] | fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
    -- LSPサーバーの起動コマンド。stdioモードまたはTCP接続を指定する。
    -- コマンドライン引数 (KotlinLspServerRunConfig.kt):
    --   --stdio                     : stdioモードで起動 (デフォルトはTCPサーバーモード)
    --   --socket=<host>:<port>      : TCPソケットアドレス (デフォルト: 127.0.0.1:9999)
    --   --client                    : クライアントモード (サーバーに接続する側になる。--stdioと併用不可)
    --   --multi-client              : マルチクライアントモード (最初のクライアント切断後もサーバーを維持。--stdio/--clientと併用不可)
    --   --system-path=<path>        : キャッシュ・インデックスの保存先パス (型: Path, デフォルト: null)
    --   --log-level=<LEVEL>         : グローバルログレベル (型: enum, デフォルト: INFO)
    --                                 値: TRACE, DEBUG, INFO, WARNING, ERROR, OFF, ALL
    --                                 環境変数 KOTLIN_LSP_LOG_LEVEL でも設定可
    --   --log-category=<cat>:<LEVEL>: カテゴリ別ログレベル (繰り返し指定可)
    --                                 例: --log-category=com.jetbrains.ls:DEBUG
    --                                 環境変数 KOTLIN_LSP_LOG_CATEGORIES でも設定可 (カンマ区切り)
    --
    -- 例:
    -- cmd = { "kotlin-lsp", "--stdio" },
    -- cmd = { "kotlin-lsp", "--stdio", "--system-path=/tmp/kotlin-lsp", "--log-level=DEBUG" },
    -- cmd = vim.lsp.rpc.connect("127.0.0.1", tonumber(9999)),

    init_options = {
        -- ## defaultJdk: string (パス)
        -- シンボル解決に使用するJDKのパス。
        -- サーバー側で initializationOptions.defaultJdk として読み取られる (initialize.kt)。
        -- 例:
        -- defaultJdk = "/usr/lib/jvm/java-21",
        -- defaultJdk = vim.fn.expand("$JAVA_HOME"),

        -- ## skipImport: boolean (デフォルト: false)
        -- trueにするとワークスペースインポート (Gradle/Maven) をスキップする。
        -- テスト・デバッグ用途。通常は設定不要。
        -- 例:
        -- skipImport = true,
    },

    -- ## root_markers: string[]
    -- プロジェクトルートを検出するためのマーカーファイル。
    -- 例:
    -- root_markers = { "build.gradle", "build.gradle.kts", "pom.xml" },

    -- ## single_file_support: boolean (デフォルト: true)
    -- プロジェクトルートが見つからない場合に単一ファイルモードで起動するか。
    -- kotlin-lspはワークスペースインポートに依存するため、falseを推奨。
    -- 例:
    -- single_file_support = false,

    -- ## settings: table
    -- workspace/configuration リクエストでサーバーに返される設定。
    -- kotlin-lspは "jetbrains.kotlin" セクションでinlay hintsの有効/無効を制御する。
    -- (LSKotlinInlayHintsProvider.kt, LSInlayHintsProviderBase.kt)
    -- 各キーは boolean 型。パスの区切りはネストされたテーブルで表現する。
    -- 例:
    -- settings = {
    --     jetbrains = {
    --         kotlin = {
    --             hints = {
    --                 settings = {
    --                     types = {
    --                         property = true,  -- プロパティの型ヒント (デフォルト: true)
    --                         variable = true,  -- ローカル変数の型ヒント (デフォルト: true)
    --                     },
    --                     lambda = {
    --                         ["return"] = true, -- ラムダのreturn式ヒント (デフォルト: true)
    --                     },
    --                     value = {
    --                         ranges = true,    -- 範囲値ヒント (デフォルト: true)
    --                     },
    --                 },
    --                 type = {
    --                     ["function"] = {
    --                         ["return"] = true,    -- 関数の戻り値型ヒント (デフォルト: true)
    --                         parameter = true,     -- 関数パラメータ型ヒント (デフォルト: true)
    --                     },
    --                 },
    --                 lambda = {
    --                     receivers = {
    --                         parameters = true, -- 暗黙のレシーバー/パラメータヒント (デフォルト: true)
    --                     },
    --                 },
    --                 value = {
    --                     kotlin = {
    --                         time = true,       -- kotlin.timeパッケージ警告ヒント (デフォルト: true)
    --                     },
    --                 },
    --                 parameters = true,          -- パラメータ名ヒント (デフォルト: true)
    --                 -- parameters = {
    --                 --     compiled = true,      -- コンパイル済みパラメータ名ヒント (デフォルト: true)
    --                 --     excluded = false,     -- 除外パラメータ名ヒント (デフォルト: false)
    --                 -- },
    --                 call = {
    --                     chains = false,          -- コールチェーンの戻り値型ヒント (デフォルト: false)
    --                 },
    --             },
    --         },
    --     },
    -- },

    ---@param client vim.lsp.Client
    ---@param initialize_result lsp.InitializeResult
    on_init = function(
        client,
        _ --[[, initialize_result]]
    )
        -- vim.print(initialize_result)
        -- Add workspace folders from includeBuild in settings.gradle
        local settings_gradle_path = vim.fn.glob(vim.env.PWD .. "/settings.gradle*", false, true)[1]
        if settings_gradle_path then
            local include_build_regex_pattern = [[\v^\s*includeBuild\("(.+)"\).*]]
            vim.iter(vim.fn.readfile(settings_gradle_path))
                :filter(
                    ---@param line string
                    ---@return boolean
                    function(line)
                        return vim.regex(include_build_regex_pattern):match_str(line) ~= nil
                    end
                )
                :map(
                    ---@param line string
                    ---@return string
                    function(line)
                        return vim.fn.substitute(line, include_build_regex_pattern, [[\1]], "")
                    end
                )
                :each(
                    ---@param name string
                    function(name)
                        vim.lsp.buf.add_workspace_folder(vim.fs.joinpath(client.root_dir, name))
                    end
                )
        end
    end,
}
