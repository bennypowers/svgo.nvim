vim.api.nvim_create_user_command('Svgo', function(args)
  require('svgo').optimize(args)
end, {
  nargs = '?',
  range = true,
  desc = 'Optimize SVG',
})
