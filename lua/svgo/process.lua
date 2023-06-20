local Util = require'svgo.util'
local uv = vim.loop

local M = {}

---@param t table
local function cat_to(t)
  return function(err, data)
    assert(not err, err)
    if data then
      for _, val in ipairs(vim.split(data, '\n')) do
        table.insert(t, val)
      end
    end
  end
end

---@param cmd string
---@param args string[]
---@param cb fun(stderr: string, stdout: string)
function M.spawn(cmd, args, cb)
  local stdin = uv.new_pipe()
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()

  if not stdin then return end
  if not stdout then return end
  if not stderr then return end

  local stdout_results = {}
  local stderr_results = {}

  local handle
  handle = uv.spawn(cmd, {
    stdio = { stdin, stdout, stderr },
    args = args,
  }, function(code, signal) -- on exit
    uv.read_stop(stdout)
    uv.read_stop(stderr)
    if not handle then return end
    if not uv.is_closing(handle) then uv.close(handle) end
    if not uv.is_closing(stdout) then uv.close(stdout) end
    if not uv.is_closing(stderr) then uv.close(stderr) end
    vim.schedule(function()
      cb(Util.join(stderr_results), Util.join(stdout_results))
    end)
  end)

  uv.read_start(stdout, cat_to(stdout_results))
  uv.read_start(stderr, cat_to(stderr_results))
end

return M
