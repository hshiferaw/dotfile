vim.schedule(function()
  vim.notify("LOADED: ~/.config/better-vim/better-vim.lua", vim.log.levels.WARN)
end)

return {
  --colorscheme = "tokyonight",
  --theme = {
  --  name = "tokyonight",
  --  colorscheme = "tokyonight-storm"
  --},

  -- ✅ ADD THIS
  --plugins = {
  -- Theme plugin
  --  {
  --    "folke/tokyonight.nvim",
  --    lazy = false,   -- load immediately
  --    priority = 1000 -- make sure it loads first
  --  },
  --plugins = {"morhetz/gruvbox",},
  --unload_plugins = {},
  --lsps = {},
  --formatters = {},
  --treesitter = {},
  --treesitter_ignore = {},
  --gitsigns = {},
  --noice = {},
  theme = {
    name = "tokyonight",
    --catppuccin_flavour = "macchiato",
    --ayucolor = "dark",
    --nightfox = {},
    --rose_pine = {
      --dark_variant = "main",
    --},
  },
  flags = {
    disable_auto_theme_loading = false,
    disable_tabs = false,
    format_on_save = false,
    experimental_tsserver = false,
  },
  --hooks = {},
  mappings = {
    leader = " ",
    tabs = nil,
    custom = {},
    by_mode = {
      n = {},
      i = {},
      v = {},
      x = {},
    },
  },
  lualine = {
    options = {},
    sections = {},
  },
  telescope = {},
  nvim_tree = {},
  whichkey = {},
  dashboard = {
    header = {},
  },




  -- Claude plugin
plugins ={
    {
      "coder/claudecode.nvim",
      dependencies = { "folke/snacks.nvim" },
      config = true,
      opts = {
        git_repo_cwd = true,
        terminal = {
          provider = "auto",
        },
      },
    }
  },

  hooks = {
    after_setup = function()
      -- keymaps
      local map = vim.keymap.set


      map("n", "<leader>b", ":vsp $BIB<CR>", { noremap = true, silent = false })
      map("n", "<leader>r", ":vsp $REFER<CR>", { noremap = true, silent = false })
      map("n", "S", ":%s//g<Left><Left>", { noremap = true, silent = false })
      --map("n", "<leader>c", ':w! | !compiler "%:p"<CR>', { noremap = true, silent = false })
      --map("n", "<leader>c", '<cmd>w! | !compiler "%:p"<CR>', { noremap = true, silent = false })
      map("n", "<leader>p", ':!opout "%:p"<CR>', { noremap = true, silent = false })
      map("n", "<leader>w", function()
        vim.wo.wrap = not vim.wo.wrap
      end, { desc = "Toggle wrap" })


      -- ensure Neovim can find ~/.local/bin
      vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/.local/bin")

      map("n", "<leader>c", function()
        vim.cmd("w!")
        -- open terminal split and run compiler on current file
        vim.cmd('botright split | resize 12 | terminal sh -lc \'compiler "%:p"; echo ""; echo "EXIT=$?"\'')
      end, {
        noremap = true,
        silent = true,
        desc = "Compile (terminal)",
      })

      -- ✅ ADD THESE KEYMAPS (Claude Code)
      map("n", "<leader>a", "", { desc = "AI / Claude Code" })
      map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
      map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
      map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
      map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
      map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
      map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
      map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })
      map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
      map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

      -- Claude layout helpers (split options) - SMART: close existing Claude terminal window and reopen with new layout
      -- Move Claude window without restarting Claude / fighting the port server
      local function claude_focus_or_open()
        -- Focus if open, otherwise open it
        pcall(vim.cmd, "ClaudeCodeFocus")
        -- If focus didn't open anything, toggle open
        -- (safe even if already open; Focus is "smart", per docs)
        pcall(vim.cmd, "ClaudeCode")
      end

      local function claude_to_bottom()
        claude_focus_or_open()
        vim.cmd("stopinsert")     -- leave terminal-mode so wincmd works predictably
        vim.cmd("wincmd J")       -- move current window to bottom
        vim.cmd("resize 15")      -- pick your preferred height
      end

      local function claude_to_right()
        claude_focus_or_open()
        vim.cmd("stopinsert")
        vim.cmd("wincmd L")       -- move current window to right
        vim.cmd("vertical resize 80") -- pick your preferred width (adjust)
      end

      map("n", "<leader>ah", claude_to_bottom, { desc = "Claude: move to bottom (horizontal)" })
      map("n", "<leader>av", claude_to_right,  { desc = "Claude: move to right (vertical)" })

      -- ⬇⬇⬇ PASTE HERE ⬇⬇⬇
      vim.opt.wrap = true
      vim.opt.linebreak = true
      vim.opt.breakindent = true
      vim.opt.showbreak = "↪ "
      -- ⬆⬆⬆ END ⬆⬆⬆

      -- sudo write
      vim.cmd([[cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!]])

      -- autocmds
      local aug = vim.api.nvim_create_augroup("bettervim_custom", { clear = true })


      -- wrap for prose
      vim.api.nvim_create_autocmd("FileType", {
        group = aug,
        pattern = { "markdown", "tex", "plaintex", "text", "gitcommit", "groff" },
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true
        end,
      })

      -- no wrap for code
      vim.api.nvim_create_autocmd("FileType", {
        group = aug,
        pattern = {
          "lua", "python", "c", "cpp", "sh", "javascript", "typescript",
          "rust", "go", "java"
      },
        callback = function()
          vim.opt_local.wrap = false
        end,
      })

      -- ⬆⬆⬆ END ⬆⬆⬆


      vim.api.nvim_create_autocmd("VimLeave", {
        group = aug,
        pattern = "*.tex",
        command = "!latexmk -c %",
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = aug,
        pattern = { "/tmp/calcurse*", "~/.calcurse/notes/*" },
        command = "set filetype=markdown",
      })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = aug,
        pattern = { "*.ms", "*.me", "*.mom", "*.man" },
        command = "set filetype=groff",
      })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = aug,
        pattern = "*.tex",
        command = "set filetype=tex",
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = aug,
        pattern = "*",
        callback = function()
          local pos = vim.fn.getpos(".")
          vim.cmd([[%s/\s\+$//e]])
          vim.cmd([[%s/\n\+\%$//e]])
          vim.fn.setpos(".", pos)
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = aug,
        pattern = "*.[ch]",
        command = [[%s/\%$/\r/e]],
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = aug,
        pattern = "*neomutt*",
        command = [[%s/^--$/-- /e]],
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = aug,
        pattern = { "bm-files", "bm-dirs" },
        command = "!shortcuts",
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = aug,
        pattern = { "Xresources", "Xdefaults", "xresources", "xdefaults" },
        command = "set filetype=xdefaults",
      })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = aug,
        pattern = { "Xresources", "Xdefaults", "xresources", "xdefaults" },
        command = "!xrdb %",
      })

      -- dwmblocks rebuild: reliable pattern + non-blocking + shows errors
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = aug,
        pattern = "*/dwmblocks/config.h",
        callback = function()
          vim.notify("dwmblocks: rebuilding...", vim.log.levels.INFO)

          vim.fn.jobstart({ "sh", "-lc",
            "cd ~/.local/src/dwmblocks && sudo -n make install && (killall -q dwmblocks || true) && setsid -f dwmblocks"
          }, {
            stderr_buffered = true,
            on_stderr = function(_, data)
              if data and data[1] ~= "" then
                vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
              end
            end,
          })
        end,
      })
    end,
  },
}
