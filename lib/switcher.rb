require "switcher/main_command"

module Switcher
  class Error < StandardError; end
end

Switcher::MainCommand.run

