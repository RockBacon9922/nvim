---@type LazySpec
return {
  {
    "mrcjkb/rustaceanvim",
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              files = {
                excludeDirs = {
                  ".direnv",
                  ".git",
                  ".jj",
                  ".github",
                  ".gitlab",
                  "bin",
                  "node_modules",
                  "target",
                  "venv",
                  ".venv",
                },
                watcher = "client",
              },
            },
          },
          cmd = function()
            local rust_analyzer = vim.fn.systemlist({ "rustup", "which", "--toolchain", "stable", "rust-analyzer" })[1]
            if vim.v.shell_error == 0 and rust_analyzer and rust_analyzer ~= "" then return { rust_analyzer } end
            return { "rust-analyzer" }
          end,
        },
      }
    end,
  },
}
