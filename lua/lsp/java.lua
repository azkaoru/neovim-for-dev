local platform = require("utils.platform")
local jdtls = require('jdtls')
local root_markers = {'gradlew', 'pom.xml','mvnw', '.git'}
local root_dir = require('jdtls.setup').find_root(root_markers)

-- java 開発用ディレクトリ（OS 非依存。Linux: ~/.local/share/java-dev, Windows: %LOCALAPPDATA%\java-dev）
local java_dev = platform.java_dev_dir()
local jdtls_dir = platform.join(java_dev, "jdtls")
local eclipse_dir = platform.join(java_dev, "eclipse")
local workspace_folder = platform.join(java_dev, "workspace", vim.fn.fnamemodify(root_dir, ":p:h:t"))

-- JDK ルートの解決。環境変数を最優先し、無ければ OS 別の既定パスを探索する。
local function first_existing(paths, fallback)
  for _, p in ipairs(paths) do
    if p and p ~= "" and vim.fn.isdirectory(p) == 1 then
      return p
    end
  end
  return fallback
end
local function jdk_path(env_name, win_defaults, unix_defaults)
  local env = os.getenv(env_name)
  if env and env ~= "" then
    return env
  end
  local defaults = platform.is_windows and win_defaults or unix_defaults
  return first_existing(defaults, defaults[1])
end

-- 各 JavaSE バージョンの JDK ルート
local jdk8  = jdk_path("JDK8_HOME",  { "C:\\Program Files\\Java\\jdk-1.8", "C:\\Program Files\\Eclipse Adoptium\\jdk-8" }, { "/usr/lib/jvm/java-1.8.0-openjdk" })
local jdk11 = jdk_path("JDK11_HOME", { "C:\\Program Files\\Java\\jdk-11", "C:\\Program Files\\Eclipse Adoptium\\jdk-11" }, { "/usr/lib/jvm/java-11-openjdk" })
local jdk17 = jdk_path("JDK17_HOME", { "C:\\Program Files\\Java\\jdk-17", "C:\\Program Files\\Eclipse Adoptium\\jdk-17" }, { "/usr/lib/jvm/java-17-openjdk" })

-- jdtls 起動に使う java 実行ファイル（JAVA_HOME 優先、無ければ JDK17）
local function java_bin(jdk_root)
  local java_home = os.getenv("JAVA_HOME")
  local root = (java_home ~= nil and java_home ~= "") and java_home or jdk_root
  return platform.join(root, "bin", platform.is_windows and "java.exe" or "java")
end

-- jdtls の構成ディレクトリ（OS 別）
local jdtls_config_dir = platform.join(
  jdtls_dir,
  platform.is_windows and "config_win" or (platform.is_mac and "config_mac" or "config_linux")
)

-- equinox launcher jar（バージョン差を吸収するため glob で解決）
local launcher_jar = vim.fn.glob(platform.join(jdtls_dir, "plugins", "org.eclipse.equinox.launcher_*.jar"))

local remap = require("me.util").remap
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  jdtls.setup_dap({ hotcodereplace = 'auto' })
  jdtls.setup.add_commands()

  -- Default keymaps
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  -- require("lsp.defaults").on_attach(client, bufnr)

  -- Java extensions
  remap("n", "<leader>jdoi", jdtls.organize_imports, bufopts, "Organize imports")
  remap("n", "<leader>jdtc", jdtls.test_class, bufopts, "Test class (DAP)")
  remap("n", "<leader>jdtm", jdtls.test_nearest_method, bufopts, "Test method (DAP)")
  remap("n", "<space>jdev", jdtls.extract_variable, bufopts, "Extract variable")
  remap("n", "<space>jdec", jdtls.extract_constant, bufopts, "Extract constant")
  remap("v", "<space>jdem", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], bufopts, "Extract method")
end

function get_libs()
    local jars_lookup_dir = vim.fn.getenv("JDTLS_JARS_LOOKUP_DIR")
    if jars_lookup_dir == vim.NIL  then
       return {}
    else
       return vim.split(vim.fn.globpath(jars_lookup_dir, '/**/*.jar'), "\n")
    end
end

local decompiler_dir = platform.join(java_dev, "projects", "dg-jdt-ls-decompiler")
local bundles = {
  vim.fn.glob(platform.join(java_dev, "projects", "java-debug", "com.microsoft.java.debug.plugin", "target", "com.microsoft.java.debug.plugin-*.jar")),
  platform.join(decompiler_dir, "dg.jdt.ls.decompiler.cfr-0.0.3.jar"),
  platform.join(decompiler_dir, "dg.jdt.ls.decompiler.common-0.0.3.jar"),
  platform.join(decompiler_dir, "dg.jdt.ls.decompiler.fernflower-0.0.3.jar"),
  platform.join(decompiler_dir, "dg.jdt.ls.decompiler.procyon-0.0.3.jar"),
}
--vim.list_extend(bundles, vim.split(vim.fn.glob(home .. '/.local/share/java-dev/projects/vscode-java-test/server/*.jar'), "\n"))

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true


local config = {
  flags = {
    debounce_text_changes = 80,
  },
  capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    bundles = bundles
  },
  root_dir = root_dir,
  settings = {
    java = {
      format = {
        settings = {
          url = platform.join(eclipse_dir, "eclipse-java-google-style.xml"),
          profile = "GoogleStyle",
        },
      },
      eclipse = {
          downloadSources = true,
      },
      maven = {
          downloadSources = true,
      },
      implementationsCodeLens = {
          enabled = true,
      },
      referencesCodeLens = {
          enabled = true,
      },
      references = {
          includeDecompiledSources = true,
      },
      inlayHints = {
          parameterNames = {
              enabled = "all",
          },
      },
       contentProvider = { preferred = 'fernflower' },
       project = {
         referencedLibraries = get_libs() ,
       },
       signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*"
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999;
          staticStarThreshold = 9999;
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = "JavaSE-11",
            path = jdk11,
          },
          {
            name = "JavaSE-17",
            path = jdk17,
          },
          {
            name = "JavaSE-1.8",
            path = jdk8,
          },
        }
      }
    },
    signatureHelp = { enabled = true },
    extendedClientCapabilities = extendedClientCapabilities,
  },
  cmd = {
    java_bin(jdk17),
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Dhttp.proxyHost=172.19.0.3',
    '-Dhttp.proxyPort=8080',
    '-Dhttps.proxyHost=172.19.0.3',
    '-Dhttps.proxyPort=8080',
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. platform.join(eclipse_dir, "lombok.jar"),
    '-jar', launcher_jar,
    '-configuration', jdtls_config_dir,
    '-data', workspace_folder,
  },
}

local M = {}
function M.make_jdtls_config()
  return config
end


function get_libs()
   return {}
end
return M
