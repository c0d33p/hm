{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      # Core dependencies
      plenary-nvim
      nui-nvim
      nvim-web-devicons
      
      # File management
      nvim-tree-lua
      telescope-nvim
      telescope-fzf-native-nvim
      
      # LSP and completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      
      # Syntax highlighting
      nvim-treesitter.withAllGrammars
      
      # UI and notifications
      nvim-notify
      lualine-nvim
      
      # Learning aids
      hardtime-nvim
      precognition-nvim
      
      # Color scheme
      gruvbox-nvim
    ];
    
    extraLuaConfig = ''
      -- Basic editor settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.autoindent = true
      vim.opt.smartindent = true
      vim.opt.wrap = false
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = true
      vim.opt.incsearch = true
      vim.opt.termguicolors = true
      vim.opt.scrolloff = 8
      vim.opt.sidescrolloff = 8
      vim.opt.mouse = "a"
      
      -- Color scheme
      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "",
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd("colorscheme gruvbox")
      
      -- Set nvim-notify as the default notification function
      vim.notify = require("notify")
      
      -- Configure nvim-notify
      require("notify").setup({
        stages = "fade_in_slide_out",
        timeout = 3000,
        top_down = false,
        background_colour = "#282828",
      })
      
      -- Configure nvim-tree
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
      })
      
      -- Configure Telescope
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git", "target" },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })
      require("telescope").load_extension("fzf")
      
      -- Configure Treesitter
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
      
      -- Configure LSP
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Nix
      lspconfig.nixd.setup({
        capabilities = capabilities,
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
            },
            formatting = {
              command = { "nixpkgs-fmt" },
            },
          },
        },
      })
      
      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = {'vim'},
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
      
      -- Rust
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      })
      
      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
      })
      
      -- TypeScript/JavaScript
      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })
      
      -- Go
      lspconfig.gopls.setup({
        capabilities = capabilities,
      })
      
      -- C/C++
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
      
      -- Haskell
      lspconfig.hls.setup({
        capabilities = capabilities,
      })
      
      -- Configure completion
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        })
      })
      
      -- Configure Lualine
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          component_separators = { left = "", right = ""},
          section_separators = { left = "", right = ""},
        },
      })
      
      -- Hardtime configuration
      require("hardtime").setup({
        max_time = 1000,
        max_count = 4,
        disable_mouse = true,
        showmode = false,
        hint = true,
        notification = true,
        allow_different_key = false,
      })
      
      -- Precognition configuration
      require("precognition").setup({
        startVisible = true,
        showBlankVirtLine = true,
        highlightColor = { link = "Comment" },
        hints = {
             Caret = { text = "^", prio = 2 },
             Dollar = { text = "$", prio = 1 },
             MatchingPair = { text = "%", prio = 5 },
             Zero = { text = "0", prio = 1 },
             w = { text = "w", prio = 10 },
             b = { text = "b", prio = 9 },
             e = { text = "e", prio = 8 },
             W = { text = "W", prio = 7 },
             B = { text = "B", prio = 6 },
             E = { text = "E", prio = 5 },
        },
        gutterHints = {
            G = { text = "G", prio = 10 },
            gg = { text = "gg", prio = 9 },
            PrevParagraph = { text = "{", prio = 8 },
            NextParagraph = { text = "}", prio = 8 },
        },
        disabled_fts = {
            "startify",
            "NvimTree",
        },
      })
      
      -- Key mappings
      vim.g.mapleader = " "
      
      -- NvimTree
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>", { desc = "Find file in explorer" })
      
      -- Telescope
      vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Help tags" })
      
      -- LSP key mappings
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
      
      -- General mappings
      vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlighting" })
      vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
      vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
    '';
  };
}
