module Rack
  module Shield
    module RequestExt
      def raw_post_data
        env['RAW_POST_DATA']
      end
    end
  end
end

Rack::Attack::Request.include Rack::Shield::RequestExt
