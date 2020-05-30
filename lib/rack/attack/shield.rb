require 'pathname'
require 'rack/attack'
require_relative 'shield/version'

module Rack
  module Attack
    module Shield
      DEFAULT_EVIL_PATHS = [/wp-(includes|content|admin)/,
                            /\.php\z/,
                            'cgi-bin',
                            'phpmyadmin',
                            'etc/passwd',
                            /\/\.env\z/]
      
      DEFAULT_EVIL_QUERIES = [/SELECT.+FROM.+/i,
                              /SELECT.+COUNT/i,
                              /SELECT.+UNION/i,
                              /INFORMATION_SCHEMA/i,
                              '--%20',
                              '-- ',
                              '%2Fscript%3E',
                              '<script>']

      class << self

        attr_accessor :evil_paths, :evil_queries
    
        def evil?(req)
          evil_paths.any? { |matcher| match?(req.path, matcher) } || 
            evil_queries.any? { |matcher| match?(req.query_string, matcher) }
        end
        
        def template
          Pathname.new(__FILE__).dirname.join('..', '..', '..', 'templates', 'shield.html')
        end
    
        private
    
        def match?(str, matcher)
          case matcher
          when String then str.include?(matcher)
          when Regexp then str.match?(matcher)
          end
        end
      end

      self.evil_paths = DEFAULT_EVIL_PATHS.dup
      self.evil_queries = DEFAULT_EVIL_QUERIES.dup
      
    end
  end
end
