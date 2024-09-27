if not IsWindows then
  return {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    keys = {
      { "<leader>cs", "<Esc><cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      { "<leader>cp", "<Esc><cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
    },
    opts = {
      has_breadcrumbs = true,
      watermark = "",
      mac_window_bar = false,
      bg_x_padding = 1,
      bg_y_padding = 1,
      bg_color = "#292D34",
      has_line_number = true
    }
  }
else
  return {}
end
