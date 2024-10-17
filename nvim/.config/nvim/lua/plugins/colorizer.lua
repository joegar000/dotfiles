return {
  "NvChad/nvim-colorizer.lua",
  opts = {
    filetypes = {
      "*",
      css = {
        names = true,
        css_fn = true
      },
      html = {
        names = true,
        css_fn = true
      },
      htmldjango = {
        names = true,
        css_fn = true
      },
      jinja = {
        names = true,
        css_fn = true
      }
    },
    user_default_options = {
      names = false,
      css_fn = false,
      css = true,
      mode = "background", -- Set the display mode.
      tailwind = true, -- Enable tailwind colors
      always_update = true
    },
    buftypes = {},
  }
}

