return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        mappings = {
          -- LazyVim's neo-tree extra maps Y to the absolute path. `y` stays
          -- neo-tree's own copy_to_clipboard (file copy/paste), so the path
          -- yanks live on Y and gY.
          --
          -- Y: path relative to the git root. Not the tree's own root, which
          -- moves with how the tree was opened (<leader>e roots at the LSP
          -- root, e.g. plugin/; <leader>E at the cwd).
          ["Y"] = {
            function(state)
              local path = state.tree:get_node().path
              local root = LazyVim.root.git()
              local rel = path:sub(1, #root + 1) == root .. "/" and path:sub(#root + 2) or path
              vim.fn.setreg("+", rel)
              vim.notify("Copied " .. rel)
            end,
            desc = "Copy Relative Path (git root)",
          },
          -- gY: absolute path
          ["gY"] = {
            function(state)
              local path = state.tree:get_node().path
              vim.fn.setreg("+", path)
              vim.notify("Copied " .. path)
            end,
            desc = "Copy Absolute Path",
          },
        },
      },
    },
  },
}
