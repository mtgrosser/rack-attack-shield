module Rack
  module Shield
    class Response
      attr_reader :env
      
      class << self
        attr_writer :template_path
        
        def template_path
          @template_path ||= if defined?(Rails)
            Rails.root.join('app', 'views', 'layouts', 'shield.html')
          else
            Pathname.new(__FILE__).dirname.join('..', '..', '..', '..', 'templates', 'shield.html')
          end
        end
        
        def call(env)
          new(env).render
        end
      end
      
      def initialize(env)
        @env = env
      end
      
      def render
        html = template_path.read
        html = html.gsub('%REQUEST_IP%', env['action_dispatch.remote_ip'].to_s)
        html = html.gsub('%EMAIL%', 'info@example.com') # TODO
        [403, { 'Content-Type' => 'text/html' }, ["#{html}\n"]]
      end
    end
  end
end
