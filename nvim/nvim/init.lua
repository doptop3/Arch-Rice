require("plugins-setup")

vim.cmd("colorscheme gruvbox")

vim.g.coc_process_timeout = 5000

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300

local keyset = vim.keymap.set

function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = true}
keyset('i', '<TAB>', [[coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()]], opts)
keyset('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
keyset('i', '<cr>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
keyset('n', '<C-n>', ':Neotree toggle<CR>', { silent = true })
keyset('n', '<F1>', '<cmd>lua RunProjectBuild()<CR>', { silent = true })
keyset('n', '<C-h>', '<C-w>h', { silent = true })
keyset('n', '<C-j>', '<C-w>j', { silent = true })
keyset('n', '<C-k>', '<C-w>k', { silent = true })
keyset('n', '<C-l>', '<C-w>l', { silent = true })
keyset('t', '<Esc>', [[<C-\><C-n>]], { silent = true })

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*/.notes.md",
    callback = function()
        vim.keymap.set('n', 'q', ":wq<CR>", { buffer = true, silent = true })
    end,
})
