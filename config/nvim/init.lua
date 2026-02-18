-- Set <space> as the leader keyinit.lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- automatically get lazy if not installed
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- getting plugins using lazy
require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason-org/mason.nvim', -- get lsp servers, formatters, linters
      'mason-org/mason-lspconfig.nvim', -- bridges mason.nvim with nvim-lspconfig
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  -- { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  -- Themes
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  { 'mrjones2014/smart-splits.nvim' }, -- smarter splits (tmux integration)

}, {})

-- Set search settings
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Make line numbers default
vim.wo.number = true

vim.o.mouse = ''
vim.o.breakindent = false
vim.o.undofile = true

vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Themes config
require("everforest").load()
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
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
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})

-- Telescope config
require('telescope').setup {
  picker = {
    layout_config = {
        width = 0.6
    },
  },
  defaults = {
    initial_mode = "insert",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.95,
      height = 0.95,
    },
    preview_cutoff = 60,
    preview_width = 0.4,
    -- NOTE: custom path display to show full path in addition to filename
    -- path_display = function(opts, path)
    --   local tail = require("telescope.utils").path_tail(path)
    --   return string.format("%s (%s)", tail, path)
    -- end,
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-/>'] = require('telescope.actions').which_key,
        ['<C-c>'] = require('telescope.actions').close,
      },
      n = {
        ['<esc>'] = false, -- don't exit on escape. Sometimes forget I am already in normal mode
        ['<C-c>'] = require('telescope.actions').close,
        ['q'] = require('telescope.actions').close,
        ['bd'] = require('telescope.actions').delete_buffer,
        ['<C-/>'] = require('telescope.actions').which_key,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = {git_root},
    })
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', function()
  require('telescope.builtin').buffers({ sort_mru = true, })
end, { desc = '[ ] Find existing buffers'})

vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = '[S]earch [s]ymbols' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').lsp_workspace_symbols, { desc = '[S]earch [w]orkspace' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'java', 'html', 'css', 'markdown' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,
    sync_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }
end, 0)

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
require("mason-lspconfig").setup {
  automatic_enable = true,
}

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    local bufnr = args.buf
    local server_name = client.name

    local nmap = function(keys, func, desc) -- remap keybind function helper
      if desc then
        desc = 'LSP: ' .. desc
      end
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    -- nmap('<M-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end,
})

-- Configure nvim-cmp
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
	-- TODO should i bring those back (collision with tmux C-n C-p
    -- ['<C-n>'] = cmp.mapping.select_next_item(),
    -- ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete {},
    ['<C-Space>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },

    -- ['<C-Enter>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif luasnip.expand_or_locally_jumpable() then
    --     luasnip.expand_or_jump()
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- Function to open diagnostics in a vertical split using location list
vim.api.nvim_create_user_command("OpenDiagnosticsVSplit", function()
  -- Populate the location list with diagnostics, but don't open it yet
  vim.diagnostic.setloclist({ open = false })
  -- Open a vertical split with the location list (like :lopen but vertical)
  vim.cmd("vertical lopen")
end, {})

vim.keymap.set("n", "ge", function()
  vim.diagnostic.setloclist({ open = false }) -- don't open and focus
  local window = vim.api.nvim_get_current_win()
  vim.cmd.lwindow() -- open+focus loclist if has entries, else close -- this is the magic toggle command
  vim.api.nvim_set_current_win(window) -- restore focus to window you were editing (delete this if you want to stay in loclist)
end, { buffer = bufnr })

-- tabs
vim.keymap.set('n', '<C-w>c', function()
  vim.cmd.tabnew()
end)

-- Terminal config
vim.keymap.set('t', '<C-w>[', '<C-\\><C-N>') -- exit terminal mode with Ctrl-w [ (reminiscent of tmux)

vim.keymap.set('n', '<leader>tt', function() -- open terminal in current window
  vim.cmd.term()
  vim.api.nvim_feedkeys('i', 'n', false) -- enter insert mode in terminal
end)

vim.keymap.set('n', '<leader>nt', function() -- open terminal in new horizontal window
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_feedkeys('i', 'n', false) -- enter insert mode in terminal
end)

vim.keymap.set('n', '<leader>vt', function() -- open terminal in new vertical window
  vim.cmd.split()
  vim.cmd.term()
  vim.cmd.wincmd("L")
  vim.api.nvim_feedkeys('i', 'n', false) -- enter insert mode in terminal
end)

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup("term-start", { clear = true }),
  callback = function()
    if vim.bo.filetype ~= 'terminal' then
      return
    end
    vim.opt.number = false
    vim.opt.relativenumber = false
  end
})

-- smart-split config
require('smart-splits').setup({
  -- Ignored buffer types (only while resizing)
  ignored_buftypes = {
    'nofile',
    'quickfix',
    'prompt',
  },
  ignored_filetypes = { }, -- Ignored filetypes (only while resizing)
  -- the default number of lines/columns to resize by at a time
  default_amount = 3,
  at_edge = 'wrap',
  float_win_behavior = 'previous',
  move_cursor_same_row = false,
  cursor_follows_swapped_bufs = false,
  ignored_events = { -- ignores some autocmd
    -- 'BufEnter',
    'WinEnter',
  },
  -- enable or disable a multiplexer integration;
  -- automatically determined, unless explicitly disabled or set,
  -- by checking the $TERM_PROGRAM environment variable,
  -- and the $KITTY_LISTEN_ON environment variable for Kitty.
  -- You can also set this value by setting `vim.g.smart_splits_multiplexer_integration`
  -- before the plugin is loaded (e.g. for lazy environments).
  multiplexer_integration = nil,
  disable_multiplexer_nav_when_zoomed = true,
  -- default logging level, one of: 'trace'|'debug'|'info'|'warn'|'error'|'fatal'
  log_level = 'info',
})

vim.keymap.set({'n', 't'}, '<A-h>', require('smart-splits').resize_left)
vim.keymap.set({'n', 't'}, '<A-j>', require('smart-splits').resize_down)
vim.keymap.set({'n', 't'}, '<A-k>', require('smart-splits').resize_up)
vim.keymap.set({'n', 't'}, '<A-l>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set({'n', 't'}, '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set({'n', 't'}, '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set({'n', 't'}, '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set({'n', 't'}, '<C-l>', require('smart-splits').move_cursor_right)
vim.keymap.set({'n', 't'}, '<C-\\>', require('smart-splits').move_cursor_previous)
-- swapping buffers between windows
vim.keymap.set({'n', 't'}, '<leader><leader>h', require('smart-splits').swap_buf_left)
vim.keymap.set({'n', 't'}, '<leader><leader>j', require('smart-splits').swap_buf_down)
vim.keymap.set({'n', 't'}, '<leader><leader>k', require('smart-splits').swap_buf_up)
vim.keymap.set({'n', 't'}, '<leader><leader>l', require('smart-splits').swap_buf_right)

-- tab navigation
vim.keymap.set('n', '<leader>tn', function() vim.cmd.tabnext() end, { desc = 'Go to [T]ab [N]ext' })
vim.keymap.set('n', '<leader>1', function() vim.cmd.tabn(1) end, { desc = 'Go to tab 1' })
vim.keymap.set('n', '<leader>2', function() vim.cmd.tabn(2) end, { desc = 'Go to tab 2' })
vim.keymap.set('n', '<leader>3', function() vim.cmd.tabn(3) end, { desc = 'Go to tab 3' })
vim.keymap.set('n', '<leader>4', function() vim.cmd.tabn(4) end, { desc = 'Go to tab 4' })
vim.keymap.set('n', '<leader>5', function() vim.cmd.tabn(5) end, { desc = 'Go to tab 5' })
vim.keymap.set('n', '<leader>6', function() vim.cmd.tabn(6) end, { desc = 'Go to tab 6' })
vim.keymap.set('n', '<leader>7', function() vim.cmd.tabn(7) end, { desc = 'Go to tab 7' })
vim.keymap.set('n', '<leader>8', function() vim.cmd.tabn(8) end, { desc = 'Go to tab 8' })
vim.keymap.set('n', '<leader>9', function() vim.cmd.tabn(9) end, { desc = 'Go to tab 9' })
vim.keymap.set('n', '<leader>0', function() vim.cmd.tablast() end, { desc = 'Go to last tab' })

-- buffer keymaps
vim.keymap.set("n", "<leader>bd", function()
  local buffer_nb = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_loaded(vim.fn.bufnr("#")) then
    vim.cmd.buffer("#") -- switch to previous buffer
  else
    -- no previous buffer, so open a new empty one first
    vim.cmd.bprevious()
  end
  -- check if buffer is open in any other window
  local win_ids = vim.fn.win_findbuf(buffer_nb)
  if #win_ids < 1 then
    -- did not switch buffer, so open a new one first
    vim.cmd.bdelete(buffer_nb)
    vim.cmd.echo('"Buffer deleted"')
    return
  end
  vim.cmd.echo('"Buffer still open in other window, not deleted"')
end, { desc = '[B]uffer [D]elete' })

vim.keymap.set({'n', 'v'}, '<leader>fb', ':lua vim.lsp.buf.format()<CR>', { desc = '[F]ormat visual [B]uffer' })

-- copilot keymaps
vim.keymap.set('i', '<C-]>', 'copilot#Accept("<CR>")', {
  expr = true,
  replace_keycodes = false,
  silent = true,
  desc = 'Accept Copilot suggestion',
})
vim.g.copilot_no_tab_map = true

vim.o.background = "dark"
vim.cmd([[set background=dark]])
vim.cmd([[set ts=4 sw=4]])
vim.cmd([[colorscheme gruvbox]])
vim.cmd([[map gn :bnext<cr>]])
vim.cmd([[map gp :bprevious<cr>]])
vim.cmd([[setlocal spell spelllang=en_us,fr]])

-- custom commands
vim.api.nvim_create_user_command('Cleanup', '%s/\\s\\+$//e', { nargs = 0 }) -- :W to write
