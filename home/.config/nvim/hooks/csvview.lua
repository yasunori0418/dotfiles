-- lua_source {{{
require("csvview").setup({
    parser = {
        --- The number of lines that the asynchronous parser processes per cycle.
        --- This setting is used to prevent monopolization of the main thread when displaying large files.
        --- If the UI freezes, try reducing this value.
        --- @type integer
        async_chunksize = 50,

        --- Specifies the delimiter character to separate columns.
        --- This can be configured in one of three ways:
        ---
        --- 1. As a single string for a fixed delimiter.
        ---    e.g., delimiter = ","
        ---
        --- 2. As a function that dynamically returns the delimiter.
        ---    e.g., delimiter = function(bufnr) return "\t" end
        ---
        --- 3. As a table for advanced configuration:
        ---    - `ft`: Maps filetypes to specific delimiters. This has the highest priority.
        ---    - `fallbacks`: An ordered list of delimiters to try for automatic detection
        ---      when no `ft` rule matches. The plugin will test them in sequence and use
        ---      the first one that highest scores based on the number of fields in each line.
        ---
        --- Note: Only fixed-length strings are supported as delimiters.
        --- Regular expressions (e.g., `\s+`) are not currently supported.
        --- @type CsvView.Options.Parser.Delimiter
        delimiter = {
            ft = {
                csv = ",",
                tsv = "\t",
            },
            fallbacks = {
                ",",
                "\t",
                ";",
                "|",
                ":",
                " ",
            },
        },

        --- The quote character
        --- If a field is enclosed in this character,
        --- it is treated as a single field and the delimiter in it will be ignored.
        --- e.g:
        ---  quote_char= "'"
        --- You can also specify it on the command line.
        --- e.g:
        --- :CsvViewEnable quote_char='
        --- @type string
        quote_char = '"',

        --- The comment prefix characters
        --- If the line starts with one of these characters, it is treated as a comment.
        --- Comment lines are not displayed in tabular format.
        --- You can also specify it on the command line.
        --- e.g:
        --- :CsvViewEnable comment=#
        --- @type string[]
        comments = {
            "#",
            "--",
            "//",
        },
    },
    view = {
        --- minimum width of a column
        --- @type integer
        min_column_width = 5,

        --- spacing between columns
        --- @type integer
        spacing = 2,

        --- The display method of the delimiter
        --- "highlight" highlights the delimiter
        --- "border" displays the delimiter with `│`
        --- You can also specify it on the command line.
        --- e.g:
        --- :CsvViewEnable display_mode=border
        ---@type CsvView.Options.View.DisplayMode
        display_mode = "border",

        --- The line number of the header row
        --- Controls which line should be treated as the header for the CSV table.
        --- This affects both visual styling and the sticky header feature.
        ---
        --- Values:
        --- - `true`: Automatically detect the header line (default)
        --- - `integer`: Specific line number to use as header (1-based)
        --- - `false`: No header line, treat all lines as data rows
        ---
        --- When a header is defined, it will be:
        --- - Highlighted with the CsvViewHeaderLine highlight group
        --- - Used for the sticky header feature if enabled
        --- - Excluded from normal data processing in some contexts
        ---
        --- See also: `view.sticky_header`
        --- @type integer|false|true
        header_lnum = true,

        --- The sticky header feature settings
        --- If `view.header_lnum` is set, the header line is displayed at the top of the window.
        sticky_header = {
            --- Whether to enable the sticky header feature
            --- @type boolean
            enabled = true,

            --- The separator character for the sticky header window
            --- set `false` to disable the separator
            --- @type string|false
            separator = "─",
        },
    },
})
-- }}}
