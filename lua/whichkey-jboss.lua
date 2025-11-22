function mvn_quarkus_dev()
  --local debug_param = ""
  --if debug then
  --  debug_param = ' -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005" '
  --end

  --local profile_param = ""
  --if profile then
  --  profile_param = " -Dspring-boot.run.profiles=" .. profile .. " "
  --end
  return 'mvn compile quarkus:dev'
end

function run_clean_install_using_current_buffer_file()
  local dir = vim.fn.expand("%:h") -- Get the current file name
  print(dir)
  --local pom = vim.fn.expand("%:p") -- Get the fullpath
  vim.cmd('term ' .. "mvn clean install -f"  .. dir .. '/' .. 'pom.xml')
end

function run_wildfly_deploy_using_current_buffer_file()
  local dir = vim.fn.expand("%:h") -- Get the current file name
  print(dir)
  --local pom = vim.fn.expand("%:p") -- Get the fullpath
  vim.cmd('term ' .. "mvn clean install wildfly:deploy -f"  .. dir .. '/' .. 'pom.xml')
end

function run_wildfly_undeploy_using_current_buffer_file()
  local dir = vim.fn.expand("%:h") -- Get the current file name
  print(dir)
  --local pom = vim.fn.expand("%:p") -- Get the fullpath
  vim.cmd('term ' .. "mvn wildfly:undeploy -f"  .. dir .. '/' .. 'pom.xml')
end

function mvn_compile()
  return 'mvn clean package'
end

function mvn_wildfly_deploy()
  return 'mvn wildfly:deploy'
end

function mvn_compile_wildfly_deploy()
  return 'mvn clean package wildfly:deploy'
end
function run_quarkus_dev(debug)
  vim.cmd('term ' .. mvn_quarkus_dev())
end

function run_compile()
  vim.cmd('term ' .. mvn_compile())
end

function run_wildfly_deploy()
  vim.cmd('term ' .. mvn_wildfly_deploy())
end

function run_compile_wildfly_deploy()
  vim.cmd('term ' .. mvn_compile_wildfly_deploy())
end

function run_mv_depend_tree()
  vim.cmd('term ' .. 'mvn dependency:tree')
end

function attach_to_quarkus_debug()
  local dap = require('dap')
  dap.configurations.java = {
    {
      type = 'java';
      request = 'attach';
      name = "Attach to the process";
      port = '5005';
    },
  }
  dap.continue()
end

function attach_to_jboss_debug()
  local dap = require('dap')
  dap.configurations.java = {
    {
      type = 'java';
      request = 'attach';
      name = "Attach to the process";
      port = '8787';
    },
  }
  dap.continue()
end


-- attach

local wk = require("which-key")
	wk.add({
-- jboss 
--{ "<leader>daq", ":lua attach_to_quarkus_debug()<CR>", desc= "Quarkus Attach", mode ="n"},


		{ "<space>j",  group = "JBoss" }, -- group
{ "<space>ja", ":lua attach_to_jboss_debug()<CR>", desc= "JBoss Attach", mode ="n"},
{ "<space>jmd", function() run_wildfly_deploy_using_current_buffer_file() end, desc= "JBoss Maven Deploy Using Current pom.xml", mode ="n"},
{ "<space>jmu", function() run_wildfly_undeploy_using_current_buffer_file() end, desc= "JBoss Maven Undeploy Using Current pom.xml", mode ="n"},
		{ "<space>m",  group = "Maven" }, -- group
{ "<space>md", function() run_mv_depend_tree() end, desc= "Maven Depend Tree", mode ="n"},
{ "<space>mp", function() run_compile() end, desc= "Maven clean package", mode ="n"},
{ "<space>mi", function() run_clean_install_using_current_buffer_file() end, desc= "Maven clean install using current's buffer pom.xml", mode ="n"},
{ "<F11>", function() run_compile() end, desc= "Maven Compile",mode ="n"},
-- { "<F12>", function() run_wildfly_deploy() end,desc= "Maven Wildfly Deploy",mode ="n"},

})


