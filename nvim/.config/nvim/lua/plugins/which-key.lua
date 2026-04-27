-- Place this file at ~/.config/nvim/lua/plugins/which-key.lua

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- How long to wait before the popup appears (ms)
    delay = 400,

    -- Show a nice icon next to each key
    icons = {
      mappings = true,
    },

    spec = {
      -- ── Your mappings ──────────────────────────────────────────────────────

      { "<leader>l",  group = "lazygit" },
      { "<leader>lg", desc = "Open LazyGit" },

      { "<leader>p",  group = "telescope" },
      { "<leader>pf", desc = "Find files (incl. hidden)" },
      { "<leader>pp", desc = "Git files" },
      { "<leader>pd", desc = "Live grep" },

      { "J", desc = "Move selection down", mode = "v" },
      { "K", desc = "Move selection up",   mode = "v" },

      { "n",     desc = "Next match (centered)" },
      { "N",     desc = "Prev match (centered)" },
      { "<C-d>", desc = "Scroll down (centered)" },
      { "<C-u>", desc = "Scroll up (centered)" },

      -- ── Windows & splits ───────────────────────────────────────────────────

      { "<C-w>",  group = "windows" },
      { "<C-w>s", desc = "Split horizontal" },
      { "<C-w>v", desc = "Split vertical" },
      { "<C-w>c", desc = "Close window" },
      { "<C-w>o", desc = "Close all other windows" },
      { "<C-w>h", desc = "Focus left" },
      { "<C-w>j", desc = "Focus down" },
      { "<C-w>k", desc = "Focus up" },
      { "<C-w>l", desc = "Focus right" },
      { "<C-w>=", desc = "Equalise window sizes" },
      { "<C-w>r", desc = "Rotate windows" },
      { "<C-w>x", desc = "Swap with next window" },
      { "<C-w>H", desc = "Move window far left" },
      { "<C-w>L", desc = "Move window far right" },

      -- ── Buffers & tabs ─────────────────────────────────────────────────────

      { "[",      group = "prev" },
      { "]",      group = "next" },
      { "[b",     desc = "Prev buffer" },
      { "]b",     desc = "Next buffer" },
      { "[t",     desc = "Prev tab" },
      { "]t",     desc = "Next tab" },

      { "<leader>b",  group = "buffers" },
      { "<leader>bd", desc = "Delete buffer" },
      { "<leader>bn", desc = "New buffer" },
      { "<leader>bo", desc = "Close all other buffers" },

      { "<leader>t",  group = "tabs" },
      { "<leader>tn", desc = "New tab" },
      { "<leader>tc", desc = "Close tab" },
      { "<leader>to", desc = "Close all other tabs" },
      { "<leader>t]", desc = "Next tab" },
      { "<leader>t[", desc = "Prev tab" },

      -- ── Diagnostics & quickfix ─────────────────────────────────────────────

      { "<leader>d",  group = "diagnostics" },
      { "<leader>dd", desc = "Show line diagnostics" },
      { "<leader>dq", desc = "Send diagnostics to quickfix" },

      { "[d",  desc = "Prev diagnostic" },
      { "]d",  desc = "Next diagnostic" },
      { "[e",  desc = "Prev error" },
      { "]e",  desc = "Next error" },
      { "[w",  desc = "Prev warning" },
      { "]w",  desc = "Next warning" },

      { "<leader>q",  group = "quickfix" },
      { "<leader>qo", desc = "Open quickfix list" },
      { "<leader>qc", desc = "Close quickfix list" },
      { "[q",         desc = "Prev quickfix item" },
      { "]q",         desc = "Next quickfix item" },

      -- ── Text objects & motions ─────────────────────────────────────────────

      { "g",   group = "go to" },
      { "gd",  desc = "Go to definition" },
      { "gD",  desc = "Go to declaration" },
      { "gr",  desc = "Go to references" },
      { "gi",  desc = "Go to implementation" },
      { "gy",  desc = "Go to type definition" },
      { "gf",  desc = "Go to file under cursor" },
      { "g;",  desc = "Go to last change" },
      { "g,",  desc = "Go to next change" },

      { "z",    group = "fold / spell" },
      { "za",   desc = "Toggle fold" },
      { "zo",   desc = "Open fold" },
      { "zc",   desc = "Close fold" },
      { "zR",   desc = "Open all folds" },
      { "zM",   desc = "Close all folds" },
      { "z=",   desc = "Spell suggestions" },
      { "zg",   desc = "Add word to spell file" },

      -- Inside / around text objects (shown in operator-pending context)
      { "i",  group = "inner",  mode = "o" },
      { "a",  group = "around", mode = "o" },
      { "iw", desc = "Inner word",      mode = { "o", "x" } },
      { "aw", desc = "Around word",     mode = { "o", "x" } },
      { "is", desc = "Inner sentence",  mode = { "o", "x" } },
      { "as", desc = "Around sentence", mode = { "o", "x" } },
      { "ip", desc = "Inner paragraph", mode = { "o", "x" } },
      { "ap", desc = "Around paragraph",mode = { "o", "x" } },
      { 'i"', desc = "Inner string",    mode = { "o", "x" } },
      { 'a"', desc = "Around string",   mode = { "o", "x" } },
      { "i(", desc = "Inner parens",    mode = { "o", "x" } },
      { "a(", desc = "Around parens",   mode = { "o", "x" } },
      { "i{", desc = "Inner block",     mode = { "o", "x" } },
      { "a{", desc = "Around block",    mode = { "o", "x" } },
      { "i[", desc = "Inner bracket",   mode = { "o", "x" } },
      { "a[", desc = "Around bracket",  mode = { "o", "x" } },
    },
  },
  keys = {
    -- Trigger which-key manually to browse ALL keymaps
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Show buffer keymaps",
    },
  },
}
