local M = {}

local function tmpdir()
  local dir = vim.env.TMPDIR or "/tmp"
  if not dir:match "/$" then dir = dir .. "/" end
  return dir
end

function M.start_server()
  local socket = tmpdir() .. "nvim-codex-" .. vim.fn.getpid() .. ".sock"
  local address_file = tmpdir() .. "nvim-codex.addr"

  local ok, address = pcall(vim.fn.serverstart, socket)
  if ok and address and address ~= "" then
    vim.g.codex_nvim_socket = address
    pcall(vim.fn.writefile, { address }, address_file)

    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("codex-snoop-server", { clear = true }),
      callback = function()
        local current = {}
        pcall(function() current = vim.fn.readfile(address_file) end)
        if current[1] == address then pcall(vim.fn.delete, address_file) end
      end,
    })
  end
end

function M.setup_review_on_save()
  local script = vim.fn.stdpath "config" .. "/bin/codex-snoop-review"
  if vim.fn.executable(script) ~= 1 then return end

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("codex-snoop-review", { clear = true }),
    callback = function(args)
      local file = vim.api.nvim_buf_get_name(args.buf)
      if file == "" or vim.bo[args.buf].buftype ~= "" then return end

      local root = vim.fs.root(file, ".git")
      if not root then return end

      vim.system({ script, file }, { cwd = root }, function() end)
    end,
  })
end

function M.setup()
  M.start_server()
  M.setup_review_on_save()
end

return M
