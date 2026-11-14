-- actionlint for GitHub workflow files (kept out of kickstart's lint.lua to avoid upstream conflicts)

vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {}

local function is_workflow(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  return path:match '/%.github/workflows/' or path:match '/%.forgejo/workflows/' or path:match '/%.gitea/workflows/'
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('custom-lint', { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].modifiable and is_workflow(args.buf) and vim.fn.executable 'actionlint' == 1 then lint.try_lint 'actionlint' end
  end,
})
