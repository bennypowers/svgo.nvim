local M = {}

---@param lines string[]
---@param sep string|nil
function M.join(lines, sep)
  return table.concat(lines, sep or '\n')
end

return M

