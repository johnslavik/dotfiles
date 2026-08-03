---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = {
    formatting = { format_on_save = { enabled = false } },
    servers = { "ruff", "ty" },
  },
}
