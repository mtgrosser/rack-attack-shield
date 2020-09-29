require 'pathname'
require 'rack/attack'
require_relative 'shield/version'
require_relative 'shield/response'

module Rack
  module Shield
    DEFAULT_EVIL_PATHS = [/\/wp-(includes|content|admin)/,
                          /\.(php|cgi|asp|aspx|shtml|log|(my)?sql(\.tar)?(\.t?(gz|zip))?|cfm|py|lasso|e?rb|pl|jsp|do|action|sh)\z/i,
                          'cgi-bin',
                          'phpmyadmin',
                          '/pma/',
                          'sqlbuddy',
                          /(my)?sql-backup/,
                          'etc/passwd',
                          '/php/',
                          '/browsedisk',
                          '/mambo/',
                          '/phpunit/',
                          '/mage/',
                          '/magento_version',
                          '/js/varien/',
                          '/includes/',
                          '/HNAP1',
                          '/nmaplowercheck',
                          '/RELEASE_NOTES.txt',
                          /\/\.(hg|git|svn|bzr|htaccess)/,
                          /\/old\/?\z/,
                          /\/\.env\z/,
                          /\A\/old-wp/,
                          /\A\/(wordpress|wp)\//]
    
    DEFAULT_EVIL_QUERIES = [/SELECT.+FROM.+/i,
                            /SELECT.+COUNT/i,
                            /SELECT.+UNION/i,
                            /UNION.+SELECT/i,
                            /INFORMATION_SCHEMA/i,
                            '--%20',
                            '-- ',
                            '%2Fscript%3E',
                            '<script>', '</script>',
                            '<php>', '</php>',
                            'XDEBUG_SESSION_START',
                            'phpstorm']

    class << self

      attr_accessor :evil_paths, :evil_queries, :response
  
      def evil?(req)
        (req.path && evil_paths.any? { |matcher| match?(req.path, matcher) }) || 
        (req.query_string && evil_queries.any? { |matcher| match?(req.query_string, matcher) })
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

    self.evil_paths   = DEFAULT_EVIL_PATHS.dup
    self.evil_queries = DEFAULT_EVIL_QUERIES.dup
    self.response     = Response
    
  end
end
