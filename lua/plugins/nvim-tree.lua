return {
  -- Desativa o neo-tree caso ele esteja ativo
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },

  -- Evita o explorer do Snacks tomar o lugar do nvim-tree
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false,
      },
      picker = {
        sources = {
          explorer = {
            enabled = false,
          },
        },
      },
    },
  },

  -- Nvim Tree limpo
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Abrir/fechar NvimTree" },
      { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Localizar arquivo no NvimTree" },
    },
    init = function()
      -- Desativa o netrw para não brigar com o nvim-tree
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      disable_netrw = true,
      hijack_netrw = true,

      view = {
        side = "left",
        width = 32,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },

      update_focused_file = {
        enable = true,
        update_root = false,
      },

      git = {
        enable = true,
        ignore = false,
      },

      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
          hint = "H",
          info = "I",
          warning = "!",
          error = "X",
        },
      },

      filters = {
        dotfiles = false,
        custom = {
          "^%.git$",
          "^%.gradle$",
          "^%.settings$",
          "^bin$",
          "^build$",
          "^%.classpath$",
          "^%.factorypath$",
          "^%.project$",
        },
      },

      renderer = {
        root_folder_label = false,
        group_empty = true,
        highlight_git = false,
        highlight_opened_files = "none",
        indent_width = 2,

        -- Aqui tira o visual “macarrônico”
        indent_markers = {
          enable = false,
        },

        icons = {
          webdev_colors = true,
          git_placement = "signcolumn",
          padding = " ",
          symlink_arrow = " -> ",

          show = {
            file = true,
            folder = true,
            folder_arrow = false,
            git = true,
          },

          glyphs = {
            default = "󰈚",
            symlink = "",

            folder = {
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },

            git = {
              unstaged = "●",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "+",
              deleted = "-",
              ignored = "◌",
            },
          },
        },
      },

      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
        },
      },
    },
  },
}
