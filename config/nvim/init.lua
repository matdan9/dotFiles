-- General vim settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Set search settings
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.mouse = ''
vim.o.breakindent = false
vim.o.undofile = true
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noinsert'

vim.o.termguicolors = true

-- automatically get lazy if not installed
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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

  { 'nvim-mini/mini.nvim', version = false },

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

  {
    "sudo-tee/opencode.nvim",
    config = function()
      require("opencode").setup({
        preferred_completion = 'vim_complete',
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { 'opencode_output' },
        },
        ft = { 'opencode_output' },
      },
      -- Optional, for file mentions picker, pick only one
      'nvim-telescope/telescope.nvim',
    },
  },

  -- Theme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
  },

  -- harpoon
  {
    'ThePrimeagen/harpoon',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      local parsers = {
        "regex", "diff", "comment", "markdown", "markdown_inline", "tsx",
        "bash",
        "c", "rust", "cpp", "glsl",
        "css", "html",
        "go", "gomod", "gowork", "gosum",
        "javascript", "typescript", "jsdoc",
        "lua", "luadoc", "luap",
        "toml", "json", "yaml",
        "vim", "vimdoc",
        "sql", "query",
        "python",
      }
      -- installed in the background, already installed parsers are skipped
      local startup_install = ts.install(parsers)

      -- install task per parser, so each parser is installed (or fails) once per session. Parsers of
      -- the startup list wait for it: a second install of the same parser blocks nvim until the first ends
      local installs = {}
      for _, lang in ipairs(parsers) do installs[lang] = startup_install end

      -- start treesitter for every buffer with a parser, installing missing parsers in the background
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match)
          if not lang or pcall(vim.treesitter.start, event.buf, lang) then return end
          if not require("nvim-treesitter.parsers")[lang] then return end -- no parser for this filetype
          installs[lang] = installs[lang] or ts.install(lang)
          installs[lang]:await(function()
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(event.buf) then pcall(vim.treesitter.start, event.buf, lang) end
            end)
          end)
        end,
      })
    end,
  },

  { -- smarter splits (tmux integration). Don't lazy load: tmux only learns a pane runs nvim when it loads
    'mrjones2014/smart-splits.nvim',
    dependencies = {
      -- sets @pane-is-vim for the bindings in tmux.conf (refuses to leave a zoomed pane by default)
      { 'smart-splits-nvim/backend-tmux', main = 'smart-splits-backend-tmux' },
    },
  },

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
      -- inline blame at the end of the cursor line, toggled with :Gblame
      current_line_blame_opts = { virt_text_pos = 'eol', delay = 300 },
      current_line_blame_formatter = '<author>, <author_time:%R> • <summary>',
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end
        -- hunk actions, vs the index (unstaged changes)
        map('n', '<leader>hs', gs.stage_hunk, '[H]unk [S]tage/unstage')
        map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, '[H]unk [S]tage selection')
        map('n', '<leader>hr', gs.reset_hunk, '[H]unk [R]eset')
        map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, '[H]unk [R]eset selection')
        map('n', '<leader>hS', gs.stage_buffer, '[H]unk [S]tage buffer')
        map('n', '<leader>hR', gs.reset_buffer, '[H]unk [R]eset buffer')
        map('n', '<leader>hp', gs.preview_hunk, '[H]unk [P]review')
        map('n', '<leader>hi', gs.preview_hunk_inline, '[H]unk preview [I]nline')
      end,
    },
  },

  -- git commands: :Git status, :Gvdiffsplit, :Git blame
  'tpope/vim-fugitive',

  -- EXTRA WORK PLUGINS
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal_cmd = "~/.local/bin/claude", -- Point to local installation
    },
    config = true,
    -- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
    -- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
    -- spec defers loading until a <leader>a* mapping is pressed and the commands
    -- would not exist yet.
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  }
}, {})

-- MINI module activations
require('mini.bracketed').setup({ -- combine '[' or ']' for motion
  -- no [<Space>/]<Space> blank line jumps
  blankline = { suffix = '' },
  -- keep the native ]c/[c (next/prev change) in diff windows
  comment = { suffix = '' },
})
require('mini.jump2d').setup({
  mappings = {
    start_jumping = 's',
  },
})

-- require('mini.ai').setup() -- better statusline
require('mini.statusline').setup() -- better statusline
require('mini.icons').setup() -- required for mini-completion
require('mini.snippets').setup({ -- required for mini-completion
  expand = {
    insert = function(snippet)
      return MiniSnippets.default_insert(snippet, { empty_tabstop = '', empty_tabstop_final = '' })
    end,
  },
})
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*:n*',
  callback = function()
    if MiniSnippets and MiniSnippets.session.get() then
      MiniSnippets.session.stop()
    end
  end,
  desc = 'Stop snippet session on Normal mode',
})
require('mini.completion').setup() -- auto complete (A-Space / C-n to trigger, C-Space to confirm)
vim.keymap.set('i', '<C-Space>', '<C-y>', { desc = 'Confirm completion selection' })
require('mini.files').setup({ mappings = { close = '<C-c>' } }) -- file explorer (':h MiniFile' '<leader>e' to open '=' to sync buff with FS)

vim.keymap.set("n",  "<C-w>z", function()
  if vim.t.zoomed then
    vim.cmd("tabclose")
    vim.t.zoomed = false
  else
    if vim.fn.tabpagenr("$") == 1 and #vim.api.nvim_tabpage_list_wins(0) == 1 then
      return -- nothing to zoom
    end
    vim.cmd("tab split")
    vim.t.zoomed = true
  end
end, { desc = "Toggle zoom (tmux-style)" })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostics: messages at the end of the line. ]d/[d jump (nvim defaults), <C-w>d shows the full
-- message, ge toggles the list, <leader>sd searches them
vim.diagnostic.config({ virtual_text = true })

-- Theme config
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
  defaults = {
    initial_mode = "insert",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.95,
      height = 0.95,
    },
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

-- HARPOON CONFIG
-- general harpoon keymaps
vim.keymap.set('n', '<leader>ha', function() require("harpoon.mark").add_file() end, { desc = '[H]arpoon [A]dd file' })
vim.keymap.set('n', '<leader>hh', function() require("harpoon.ui").toggle_quick_menu() end, { desc = '[H]arpoon [H]ome' })
-- harpoon naf file
vim.keymap.set({'n', 't'}, '<M-1>', function() require("harpoon.ui").nav_file(1) end, { desc = 'Harpoon file 1' })
vim.keymap.set({'n', 't'}, '<M-2>', function() require("harpoon.ui").nav_file(2) end, { desc = 'Harpoon file 2' })
vim.keymap.set({'n', 't'}, '<M-3>', function() require("harpoon.ui").nav_file(3) end, { desc = 'Harpoon file 3' })
vim.keymap.set({'n', 't'}, '<M-4>', function() require("harpoon.ui").nav_file(4) end, { desc = 'Harpoon file 4' })
vim.keymap.set({'n', 't'}, '<M-5>', function() require("harpoon.ui").nav_file(5) end, { desc = 'Harpoon file 5' })
-- harpoon terminal keymaps
vim.keymap.set({'n', 't'}, '<M-0>', function() require("harpoon.term").gotoTerminal(1) end, { desc = 'Harpoon terminal 1' })
vim.keymap.set({'n', 't'}, '<M-9>', function() require("harpoon.term").gotoTerminal(2) end, { desc = 'Harpoon terminal 2' })
vim.keymap.set({'n', 't'}, '<M-8>', function() require("harpoon.term").gotoTerminal(3) end, { desc = 'Harpoon terminal 3' })
vim.keymap.set({'n', 't'}, '<M-7>', function() require("harpoon.term").gotoTerminal(4) end, { desc = 'Harpoon terminal 4' })
vim.keymap.set({'n', 't'}, '<M-6>', function() require("harpoon.term").gotoTerminal(5) end, { desc = 'Harpoon terminal 5' })


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
vim.keymap.set('n', '<leader><space>', function()
  require('telescope.builtin').buffers({ sort_mru = true, })
end, { desc = '[ ] Find existing buffers'})

vim.keymap.set('n', '<leader>ft', function()
  require('telescope.builtin').buffers({ sort_mru = true, cwd = "term://" })
end, { desc = '[F]ind existing [T]erminals'})

vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = '[S]earch [s]ymbols' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').lsp_workspace_symbols, { desc = '[S]earch [w]orkspace' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').keymaps, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>fq', require('telescope.builtin').quickfix, { desc = '[F]ind [Q]uickfix' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>fQ', require('telescope.builtin').quickfixhistory, { desc = '[F]ind [Q]uickfix history' })

-- GIT CONFIG
-- Review loop: <leader>gs lists the changed files, <C-q> sends them to quickfix, ]q/[q goes from file
-- to file, ]h/[h from hunk to hunk and <leader>gd shows the whole file side by side with its diff.
-- Gutter signs, hunks and diffs are against the index, i.e. unstaged changes

-- show whole files in diffs instead of folding the unchanged lines away (<leader>gz toggles the folding)
vim.opt.diffopt:append('context:99999')

-- Side-by-side diff that follows its window: <leader>gd turns it on for the current window, then every
-- file shown there (]q/[q, :e, pickers...) is diffed in place, without adding splits, until it's turned off
local diff_follow = { busy = false, pending = false }

-- close the "before" window of the diff, or for a diff opened some other way, its git object windows
local function diff_close_side()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local sides = vim.tbl_filter(function(win) return vim.w[win].git_diff_side end, wins)
  if #sides == 0 then
    sides = vim.tbl_filter(function(win)
      return vim.wo[win].diff and vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)):match('^fugitive://')
    end, wins)
  end
  for _, win in ipairs(sides) do pcall(vim.api.nvim_win_close, win, true) end
  vim.cmd('diffoff!')
end

-- open the "before" side of the current buffer's diff, keeping the cursor where it is
local function diff_open_side()
  local main = vim.api.nvim_get_current_win()
  if vim.bo.buftype ~= '' then return end -- terminal, help, quickfix...
  local before = vim.api.nvim_tabpage_list_wins(0)
  local ok, err = pcall(vim.cmd, 'Gvdiffsplit')
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if not vim.tbl_contains(before, win) then vim.w[win].git_diff_side = true end
  end
  if vim.api.nvim_win_is_valid(main) then vim.api.nvim_set_current_win(main) end
  if not ok then vim.notify('No git diff for this file: ' .. err, vim.log.levels.WARN) end
end

-- re-diff after a file was shown in the followed window, or in its "before" window (then move it over)
local function diff_follow_update(win)
  local main = vim.t.git_diff_main
  if not (main and vim.api.nvim_win_is_valid(main)) then
    vim.t.git_diff_main = nil
    return
  end
  diff_follow.busy = true
  pcall(function()
    if win ~= main and vim.api.nvim_win_is_valid(win) then
      local cursor = vim.api.nvim_win_get_cursor(win)
      vim.api.nvim_win_set_buf(main, vim.api.nvim_win_get_buf(win))
      vim.api.nvim_win_set_cursor(main, cursor)
    end
    vim.api.nvim_set_current_win(main)
    diff_close_side()
    diff_open_side()
  end)
  diff_follow.busy = false
end

local function toggle_diff_follow()
  if vim.t.git_diff_main or vim.wo.diff then
    vim.t.git_diff_main = nil
    diff_close_side()
    return
  end
  vim.t.git_diff_main = vim.api.nvim_get_current_win()
  diff_follow.busy = true
  pcall(diff_open_side)
  diff_follow.busy = false
end

local diff_follow_group = vim.api.nvim_create_augroup('git-diff-follow', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = diff_follow_group,
  callback = function()
    local win = vim.api.nvim_get_current_win()
    if diff_follow.busy or diff_follow.pending or not vim.t.git_diff_main then return end
    if win ~= vim.t.git_diff_main and not vim.w[win].git_diff_side then return end
    diff_follow.pending = true
    vim.schedule(function()
      diff_follow.pending = false
      diff_follow_update(win)
    end)
  end,
})
vim.api.nvim_create_autocmd('WinClosed', {
  group = diff_follow_group,
  callback = function(ev)
    if tonumber(ev.match) == vim.t.git_diff_main then
      vim.t.git_diff_main = nil
      vim.schedule(diff_close_side)
    end
  end,
})

-- next/prev change: native diff jump inside diff windows, gitsigns hunk otherwise
vim.keymap.set({ 'n', 'x' }, ']h', function()
  if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else require('gitsigns').nav_hunk('next') end
end, { desc = 'Jump to next change' })
vim.keymap.set({ 'n', 'x' }, '[h', function()
  if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else require('gitsigns').nav_hunk('prev') end
end, { desc = 'Jump to previous change' })

vim.keymap.set('n', '<leader>gg', '<cmd>Git<cr>', { desc = '[G]it status (fugitive)' })
-- <C-q> sends the files to quickfix, <Tab> stages/unstages a file
vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { desc = '[G]it [S]tatus changed files' })
vim.keymap.set('n', '<leader>gd', toggle_diff_follow, { desc = '[G]it [D]iff that follows the window (toggle)' })
vim.keymap.set('n', '<leader>gz', function()
  if vim.o.diffopt:find('context:99999', 1, true) then
    vim.opt.diffopt:remove('context:99999')
  else
    vim.opt.diffopt:append('context:99999')
  end
end, { desc = '[G]it diff fold unchanged lines (toggle)' })
vim.keymap.set('n', '<leader>gf', function()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  require('telescope.builtin').git_bcommits({
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local sha = action_state.get_selected_entry().value
        actions.close(prompt_bufnr)
        vim.cmd('Gvdiffsplit ' .. sha)
      end)
      return true
    end,
  })
end, { desc = '[G]it [F]ile history' })
vim.keymap.set('n', '<leader>gb', function() require('gitsigns').blame_line({ full = true }) end, { desc = '[G]it [B]lame line' })
vim.keymap.set('n', '<leader>gA', '<cmd>Git blame<cr>', { desc = '[G]it [A]nnotate file (blame)' })

vim.api.nvim_create_user_command('Blame', 'Git blame', { desc = 'Show git blame for current file' })
vim.api.nvim_create_user_command('Diff', toggle_diff_follow, { desc = 'Toggle side-by-side diff that follows the window' })
vim.api.nvim_create_user_command('Gblame', function()
  local enabled = require('gitsigns').toggle_current_line_blame()
  vim.notify('Inline blame ' .. (enabled and 'on' or 'off'))
end, { desc = 'Toggle blame at the end of the cursor line' })

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup({ automatic_enable = true }) -- enable every server installed with mason

-- remove nvim's default gr* LSP maps (grn, gra, grr, gri, grt, grx), otherwise `gr` waits for
-- timeoutlen before running. The LspAttach maps below cover the same actions
for _, keys in ipairs({ 'grn', 'gra', 'grr', 'gri', 'grt', 'grx' }) do
  pcall(vim.keymap.del, 'n', keys)
end
pcall(vim.keymap.del, 'x', 'gra')

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

vim.keymap.set("n", "ge", function()
  vim.diagnostic.setloclist({ open = false }) -- don't open and focus
  local window = vim.api.nvim_get_current_win()
  vim.cmd.lwindow() -- open+focus loclist if has entries, else close -- this is the magic toggle command
  vim.api.nvim_set_current_win(window) -- restore focus to window you were editing (delete this if you want to stay in loclist)
end, { desc = 'Toggle diagnostics list' })

-- tabs (tmux-style: <C-w>c is a new tab, <C-w>q closes a window)
vim.keymap.set('n', '<C-w>c', function()
  vim.cmd.tabnew()
end, { desc = 'New tab (tmux-style)' })

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

-- nvim already removes line numbers from terminals, also turn off spell checking there
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup("term-start", { clear = true }),
  callback = function()
    vim.opt_local.spell = false
  end
})

-- make nvim follow cwd of terminal (the shell's cwd, so it works after cd, z, pushd...)
vim.api.nvim_create_autocmd({'BufEnter', 'TermEnter', 'TermLeave'}, {
  desc = "cd to cwd on enter",
  pattern = "term://*",
  callback = function()
    if not vim.b.terminal_job_pid then return end
    local cwd = vim.fn.resolve('/proc/' .. vim.b.terminal_job_pid .. '/cwd')
    if vim.fn.isdirectory(cwd) == 0 then return end
    vim.fn.chdir(cwd)
  end,
})

-- smart-split config
require('smart-splits').setup({
  -- Ignored buffer types (only while resizing)
  ignored_buftypes = {
    'nofile',
    'quickfix',
    'prompt',
  },
  ignored_filetypes = { }, -- Ignored filetypes
  resize = {
    amount = 3, -- the default number of lines/columns to resize by at a time
    ignored_events = { -- ignores some autocmd while resizing
      -- 'BufEnter',
      'WinEnter',
    },
  },
  move = {
    at_edge = 'wrap', -- keep in step with the tmux.conf bindings, which wrap too
    same_row = false,
    float = 'previous',
  },
  swap = { move_cursor = false },
  mux = {
    -- no auto-detection anymore, the backend plugin has to be named
    backend = 'smart-splits-backend-tmux',
    warn_if_unusable = false, -- don't warn when nvim runs outside tmux
  },
  -- logging level, one of: 'trace'|'debug'|'info'|'warn'|'error'
  log = { level = 'info' },
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
-- smart-splits dropped move_cursor_previous, go to the previous nvim window instead
vim.keymap.set({'n', 't'}, '<C-\\>', function() vim.cmd.wincmd('p') end)
-- swapping buffers between windows
vim.keymap.set({'n'}, '<leader><leader>h', require('smart-splits').swap_buf_left)
vim.keymap.set({'n'}, '<leader><leader>j', require('smart-splits').swap_buf_down)
vim.keymap.set({'n'}, '<leader><leader>k', require('smart-splits').swap_buf_up)
vim.keymap.set({'n'}, '<leader><leader>l', require('smart-splits').swap_buf_right)

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

-- open file explorer
vim.keymap.set('n', '<leader>e', ':lua MiniFiles.open()<CR>', { desc = '[E]xplorer' })

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


-- NOTE: if not working with visual selection, the LSP/formatter isn't supporting rage formatting
vim.keymap.set({'n', 'v'}, '<leader>fb', function() vim.lsp.buf.format() end, { desc = '[F]ormat visual [B]uffer' })

-- fix floating window not having the same background as normal windows
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = normal.fg, bg = normal.bg, })
  end,
})
-- set the color scheme
vim.o.background = "dark"
vim.cmd.colorscheme("gruvbox")

-- spell checking everywhere (in code, treesitter limits it to comments and strings)
vim.o.spell = true
vim.o.spelllang = 'en_us' -- 'en_us,fr'

-- force tab settings for makefiles
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
vim.api.nvim_create_user_command('Cleanup', '%s/\\s\\+$//e', { nargs = 0 }) -- :Cleanup trim the trailing white spaces
vim.api.nvim_create_user_command('Table', "<line1>,<line2>!column -t -s '|' -o '|'", { range = true }) -- :'<,'>Table to format markdown tables

-- some extra neovide controls
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.10)
  end, { desc = 'Neovide zoom in' })
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1/1.10)
  end, { desc = 'Neovide zoom out' })
end

