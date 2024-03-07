return {{
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = { 
      -- "c", "cpp", "cmake", "make", 
      "lua", "luadoc", 
      "vim", "vimdoc", 
      -- "sql", 
      "bash",
      -- "html", "css", "javascript", "typescript",
      -- "go",
      -- "python",
      "tmux", "toml", "yaml", "ssh_config", "regex",
      "query",
    },
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function (_, opts)
    require("nvim-treesitter.install").prefer_git = true
    local configs = require("nvim-treesitter.configs")
    configs.setup(opts)
  end
}}
