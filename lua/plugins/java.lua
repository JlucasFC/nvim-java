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

  -- jdtls via Homebrew usando Java 21 + lombok baixado manualmente
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      local java21_home = "/var/home/linuxbrew/.linuxbrew/opt/openjdk@21/libexec"
      local cmd = {
        "/usr/bin/env",
        "JAVA_HOME=" .. java21_home,
        vim.fn.exepath("jdtls"),
      }
      local lombok_jar = vim.fn.expand("~/.local/share/nvim/lombok.jar")
      local uv = vim.uv or vim.loop

      if uv.fs_stat(lombok_jar) then
        table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
      end

      local function fix_missing_semicolons(bufnr)
        local diagnostics = vim.diagnostic.get(bufnr)

        for _, diagnostic in ipairs(diagnostics) do
          if diagnostic.source == "Java" and diagnostic.message:find('insert ";"', 1, true) then
            local line = vim.api.nvim_buf_get_lines(bufnr, diagnostic.lnum, diagnostic.lnum + 1, false)[1]

            if line and not line:match(";%s*$") then
              vim.api.nvim_buf_set_lines(bufnr, diagnostic.lnum, diagnostic.lnum + 1, false, { line .. ";" })
            end
          end
        end
      end

      local function organize_imports(bufnr)
        local client = vim.lsp.get_clients({ bufnr = bufnr, name = "jdtls" })[1]
        if not client then
          return
        end

        local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
        params.context = { diagnostics = {} }

        local response = client:request_sync("java/organizeImports", params, 3000, bufnr)
        if response and response.result then
          vim.lsp.util.apply_workspace_edit(response.result, client.offset_encoding)
        end
      end

      local group = vim.api.nvim_create_augroup("java_save_actions", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        pattern = "*.java",
        callback = function(event)
          fix_missing_semicolons(event.buf)
          organize_imports(event.buf)
        end,
      })

      opts.cmd = cmd
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = java21_home,
                default = true,
              },
            },
          },
        },
      })
    end,
  },
}
