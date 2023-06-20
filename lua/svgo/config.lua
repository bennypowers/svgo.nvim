local M = {}

function M.get_default_config_path()
  -- path to this file i.e. svgo.lua
  local mod = debug.getinfo(1,'S').source:gsub('@', '')
  local sep = mod:match[[([\/])]]
  local path = mod:gsub('lua'..sep..'svgo'..sep..'config%.lua', 'svgo.config.js')
  return path
end

return M
