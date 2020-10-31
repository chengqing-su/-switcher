require 'clamp'
require 'tty-prompt'
require 'switcher/commands/aws'
require 'switcher/commands/kubernetes'

module Switcher
  class MainCommand < Clamp::Command

    option "--version", :flag, "Show version" do
      puts Switcher::VERSION
    end

    def execute
      command = prompt.select("What do you want to do?") do |menu|
        menu.choice "AWS", -> { Switcher::Commands::Aws }
        menu.choice "Kubernetes", -> { Switcher::Commands::Kubernetes }
      end
      choice_command(command)
    end

    private

    def choice_command(parent_command)
      subcommand = parent_command.find_subcommand_class(choice_subcommand(parent_command))
      if subcommand.has_subcommands?
        choice_command(subcommand)
      else
        subcommand.new(invocation_path, context).execute
      end
    end

    def choice_subcommand(parent_command)
      prompt.select("which subcommand you want to execute?", subcommand_names(parent_command))
    end

    def subcommand_names(parent_command)
      parent_command.recognised_subcommands.map { |subcommand| subcommand.names }.flatten
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end

  end
end