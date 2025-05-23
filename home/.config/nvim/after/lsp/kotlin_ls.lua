return {
    cmd = { "kotlin-ls", "--stdio" },
    single_file_support = true,
    filetypes = { "kotlin" },
    root_markers = { "build.gradle", "build.gradle.kts", "pom.xml" },
}
