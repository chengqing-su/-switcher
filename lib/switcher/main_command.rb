require 'clamp'
require 'tty-prompt'
require 'switcher/commands/aws'

module Switcher
  class MainCommand < Clamp::Command

    option "--version", :flag, "Show version" do
      puts Switcher::VERSION
    end

    subcommand 'aws','AWS Helper', Switcher::Commands::Aws

    def execute
      request_help
    end

    private

    def prompt
      @prompt ||= TTY::Prompt.new
    end

  end
end