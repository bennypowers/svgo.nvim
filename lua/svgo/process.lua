local M = {}

---@param cmd string
---@param args string[]
---@param cb fun(stderr: string, stdout: string)
function M.spawn(cmd, args, cb)
  vim.system({ cmd, unpack(args) }, { text = true }, function(result)
    vim.schedule(function()
      cb(result.stderr or '', result.stdout or '')
    end)
  end)
end

return M
