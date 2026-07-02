return {
  { import = "lazyvim.plugins.extras.lang.java" },

  -- Impede o mason-lspconfig de gerenciar o jdtls (usamos o do Homebrew)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {
          mason = false,
        },
      },
    },
  },

  -- java-debug-adapter e java-test continuam via Mason normalmente
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for _, pkg in ipairs({ "java-debug-adapter", "java-test" }) do
        if not vim.tbl_contains(opts.ensure_installed, pkg) then
          table.insert(opts.ensure_installed, pkg)
        end
      end
    end,
  },

  -- jdtls via Homebrew + lombok baixado manualmente
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      local cmd = { vim.fn.exepath("jdtls") }
      local lombok_jar = vim.fn.expand("~/.local/share/nvim/lombok.jar")
      local uv = vim.uv or vim.loop
      if uv.fs_stat(lombok_jar) then
        table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
      end
      opts.cmd = cmd
    end,
  },
}
