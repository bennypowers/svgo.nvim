# svgo.nvim 🗜️

Run [svgo][svgo] on the current buffer or a string.

Bundles some defaults that I like, see [./svgo.config.js][config]

```lua
return { 'bennypowers/svgo.nvim',
  opts = {
    -- uses the bundled config by default, override by passing a config path
    config = vim.fn.expand('~/.config/svgo/svgo.config.js')
  }
}
```

This initial implementation was pretty quick and dirty. In the future, this 
plugin should probably shell out to node and pass config from lua, or use nvim 
RPC to do the same.

[svgo]: https://github.com/svg/svgo/
[config]: ./svgo.config.js
