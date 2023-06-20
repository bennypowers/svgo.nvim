local M = {}

local Conf = require'svgo.config'
local Proc = require'svgo.process'
local Util = require'svgo.util'

local user_opts = {
  config = Conf.get_default_config_path(),
}

local function get_args(opts, content)
  local call_opts = vim.tbl_extend('force', user_opts, opts)
  return {
    '--config',
    call_opts.config,
    '--string',
    content,
    '--output',
    '-', -- stdout
  }
end

function M.setup(opts)
  user_opts = vim.tbl_extend('force', user_opts, opts)
  vim.api.nvim_create_user_command('Svgo', function(args)
    local text = args.fargs[1]
    local cb
    if args.range == 2 then
      text = Util.join(vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, false))
      cb = function(optimized)
        vim.api.nvim_buf_set_lines(0, args.line1 - 1, args.line2, false, vim.split(optimized, '\n'))
      end
    end
    M.svgo(user_opts, text, cb)
  end, {
    nargs = '?',
    range = true,
    desc = 'Optimize SVG',
  })
end

function M.svgo(opts, svg_string, cb)
  if svg_string then
    local args = get_args(opts, svg_string)
    Proc.spawn('svgo', args, function(stderr, stdout)
      if stderr:len() > 0 then
        print('[svgo.nvim] ERROR: ' .. stderr)
      else
        cb(stdout)
      end
    end)
  else
    if vim.bo.filetype ~= 'svg' then return end
    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
    local args = get_args(opts, content)
    Proc.spawn('svgo', args, function(stderr, stdout)
      if stderr:len() > 0 then
        print('[svgo.nvim] ERROR: ' .. stderr)
      else
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(stdout, '\n'))
      end
    end)
  end
end

return M
