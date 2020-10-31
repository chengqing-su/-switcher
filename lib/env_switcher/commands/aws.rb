require 'json'

module EnvSwitcher
  module Commands
    class Aws < Clamp::Command

      def initialize(invocation_path, context = nil)
        ensure_aws_cli_config_dir
        ensure_aws_config_dir
        super
      end

      subcommand 'add', 'add aws credentials' do
        def execute
          add
        end
      end

      subcommand 'clean', 'clean aws credentials' do
        def execute
          change_aws_credentials
          change_aws_config
        end
      end

      subcommand 'switch', 'switch aws credential' do
        def execute
          switch
        end
      end

      def execute
        request_help
      end

      private

      def switch
        if aws_config.keys.empty?
          prompt.error("please add an aws account at first")
          return
        end

        result = prompt.select("which aws account you want to use?", aws_config.keys)

        change_aws_credentials(aws_config[result]['aws_access_key_id'], aws_config[result]['aws_secret_access_key'])
        change_aws_config(aws_config[result]['region'])
      end

      def change_aws_credentials(aws_access_key_id = "", aws_secret_access_key = "")
        credentials = "
[default]
aws_access_key_id=#{aws_access_key_id}
aws_secret_access_key=#{aws_secret_access_key}"
        File.write(File.expand_path('~/.aws/credentials'), credentials)
      end

      def change_aws_config(region = "")
        config = "
[default]
region=#{region}
output=json"

        File.write(File.expand_path('~/.aws/config'), config)
      end

      def add
        result = prompt.collect do
          key(:account_number).ask("Account Number?", required: true)

          key(:region).ask("Region?", default: 'ap-southeast-1')
          key(:alias).ask("Alias?",)
          key(:aws_access_key_id).ask("AWS Access Key Id?", required: true)
          key(:aws_secret_access_key).ask("AWS Secret Access Key?", required: true)
        end

        aws_config[aws_name(result[:alias], result[:account_number])] = result

        File.write(aws_config_path, JSON.pretty_generate(aws_config))
      end

      def aws_name(name, account_number)
        name.nil? ? account_number : "#{name}(#{account_number})"
      end

      def aws_config
        @aws_config ||= (File.exists?(aws_config_path) ? JSON.parse(File.read(aws_config_path)) : Hash.new)
      end

      def aws_config_path
        File.expand_path('~/.env_switcher/aws/config.json')
      end

      def prompt
        @prompt ||= TTY::Prompt.new
      end

      def ensure_aws_cli_config_dir
        ensure_dir '~/.aws'
      end

      def ensure_aws_config_dir
        ensure_dir '~/.env_switcher'
        ensure_dir '~/.env_switcher/aws'
      end

      def ensure_dir(dir_name)
        dir_path = File.expand_path(dir_name)
        Dir.mkdir dir_path unless Dir.exists? dir_path
      end
    end
  end
end
