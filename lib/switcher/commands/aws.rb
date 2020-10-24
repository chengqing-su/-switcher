
module Switcher
  module Commands
    class Aws < Clamp::Command

      def initialize(invocation_path, context = nil)
        ensure_aws_cli_config_dir
        ensure_aws_config_dir
        super
      end

      subcommand 'add','add aws credentials' do
        def execute
          add
        end
      end

      def execute
        request_help
      end

      private

      def add
        prompt.ask
      end

      def prompt
        @prompt ||= TTY::Prompt.new
      end

      def ensure_aws_cli_config_dir
        ensure_dir '~/.aws'
      end

      def ensure_aws_config_dir
        ensure_dir '~/.switcher'
        ensure_dir '~/.switcher/aws'
      end

      def ensure_dir(dir_name)
        dir_path = File.expand_path(dir_name)
        Dir.mkdir dir_path unless Dir.exists? dir_path
      end
    end
  end
end
