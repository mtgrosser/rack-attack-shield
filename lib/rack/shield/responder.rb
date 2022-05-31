module Rack
  module Shield
    class Responder
      attr_reader :request
      
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
        
        def call(request)
          new(request).render
        end
      end
      
      def initialize(request)
        @request = request
      end
      
      def env
        request.env
      end
      
      def render
        return [403, { 'Content-Type' => 'text/html' }, []] if head?
        html = self.class.template.read.gsub('%REQUEST_IP%', request_ip.to_s)
        [403, { 'Content-Type' => 'text/html' }, ["#{html}\n"]]
      end
      
      private
      
      def request_ip
        env['HTTP_X_REAL_IP'] || env['REMOTE_ADDR']
      end
      
      def head?
        request.head?
      end
    end
  end
end
