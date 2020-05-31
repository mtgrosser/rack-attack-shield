module Rack
  module Shield
    class Response
      attr_reader :env
      
      class << self
        attr_writer :template
        
        def template
          @template ||= if defined?(Rails)
            Rails.root.join('app', 'views', 'layouts', 'shield.html')
          else
            default_template
          end
        end
        
        def default_template
          Pathname.new(__FILE__).dirname.join('..', '..', '..', '..', 'templates', 'shield.html')
        end
        
        def call(env)
          new(env).render
        end
      end
      
      def initialize(env)
        @env = env
      end
      
      def render
        html = self.class.template.read.gsub('%REQUEST_IP%', env['REMOTE_ADDR'].to_s)
        [403, { 'Content-Type' => 'text/html' }, ["#{html}\n"]]
      end
    end
  end
end
