module Rack
  module Shield
    module RequestExt
      def raw_post_data
        if body
          data = body.read
          body.rewind
          data
        end
      end
    end
  end
end

Rack::Attack::Request.include Rack::Shield::RequestExt
