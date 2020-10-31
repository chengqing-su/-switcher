require "env_switcher/main_command"

module EnvSwitcher
  class Error < StandardError; end
end

EnvSwitcher::MainCommand.run

