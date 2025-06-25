local root_markers = {
    ".git",
    "build.gradle",
    "build.gradle.kts",
    "pom.xml",
    "settings.gradle",
    "settings.gradle.kts",
}

---@type vim.lsp.Config
return {
    cmd = { "kotlin-ls", "--stdio" },
    single_file_support = true,
    filetypes = { "kotlin" },
    root_markers = root_markers,
}
