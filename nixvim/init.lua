vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 10
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.ruler = true
vim.opt.smarttab = true
vim.opt.softtabstop = 0
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

--vim.cmd.colorscheme("gruvbox")
vim.cmd.colorscheme("catppuccin")

vim.g.mapleader = " "

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- Keymaps
keymap("i", "jk", "<Esc>", { noremap = true, nowait = true })
keymap("n", "<leader>p", ":Ex<CR>", {})
keymap("n", "<leader>d", "\"_d", {})
keymap("v", "<leader>d", "\"_d", {})
keymap("v", "<leader>p", "\"_dP", {})
keymap("n", "<C-d>", "<C-d>zz", {})
keymap("n", "<C-u>", "<C-u>zz", {})
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)

-- LSP-related (using Lua functions directly)
local opts = { noremap=true, silent=true, buffer=bufnr }
keymap('n', '<leader>gd', vim.lsp.buf.definition, opts)
keymap('n', '<leader>gr', vim.lsp.buf.references, opts)
keymap('n', '<leader>rn', vim.lsp.buf.rename, opts)
keymap('n', '<leader>ca', vim.lsp.buf.code_action, opts)
keymap('n', '<leader>e', vim.diagnostic.open_float, opts)
keymap('n', '<leader>ep', vim.diagnostic.goto_prev, opts)
keymap('n', '<leader>en', vim.diagnostic.goto_next, opts)


-- Telescope (commands as strings, no direct Lua function wrapper)
keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)

-- Buffer navigation
keymap('n', '<C-l>', '<cmd>bn<CR>', opts)
keymap('n', '<C-h>', '<cmd>bp<CR>', opts)

-- Cargo
keymap('n', '<leader>cb', '<cmd>!cargo build<CR>', opts)
keymap('n', '<leader>cr', '<cmd>!cargo run<CR>', opts)
-- LSP Setup
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
	on_attach = on_attach,
})
lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
})
lspconfig.nil_ls.setup({})

-- Completion
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    { name = "luasnip" },
  }),
})

