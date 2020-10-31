require 'yaml'

module EnvSwitcher
  module Commands
    class Kubernetes < Clamp::Command
      subcommand 'switch', 'switch kubernetes context' do
        def execute
          switch
        end
      end

      subcommand 'eks', 'Add kubernetes context from AWS EKS' do
        def execute
          add_eks_cluster_to_contexts
        end
      end

      def execute
        request_help
      end

      private

      def add_eks_cluster_to_contexts
        choose_eks_clusters.each { |cluster_name| `aws eks update-kubeconfig --name #{cluster_name}` }
      end

      def choose_eks_clusters
        prompt.multi_select("Choose EKS clusters: ", list_eks_cluster_names)
      end

      def list_eks_cluster_names
        JSON.parse(`aws eks list-clusters --query clusters --output json`)
      end

      def switch
        `kubectl config use-context #{select_kubernetes_context}`
      end

      def select_kubernetes_context
        prompt.select("Switch to ", kubernetes_context_names)
      end

      def kubernetes_context_names
        `kubectl config get-contexts -o name`.split("\n")
      end

      def prompt
        @prompt ||= TTY::Prompt.new
      end
    end
  end
end
