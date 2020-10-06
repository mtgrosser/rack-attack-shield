require 'pathname'
require 'rack/attack'
require_relative 'shield/version'
require_relative 'shield/response'

module Rack
  module Shield
    DEFAULT_PATHS = [/\/wp-(includes|content|admin)/,
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
                    '/varien/js.js',
                    'RELEASE_NOTES.txt',
                    '/phpunit/',
                    '/mage/',
                    '/magento_version',
                    '/js/varien/',
                    '/includes/',
                    '/HNAP1',
                    '/nmaplowercheck',
                    '/solr/admin/',
                    '/axis2/axis2-admin',
                    '/RELEASE_NOTES.txt',
                    /\/\.(hg|git|svn|bzr|htaccess)/,
                    /\/old\/?\z/,
                    /\/\.env\z/,
                    /\A\/old-wp/,
                    /\A\/(wordpress|wp)(\/|\z)/]
    
    DEFAULT_QUERIES = [/SELECT.+FROM.+/i,
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

      attr_accessor :paths, :queries, :checks, :response
  
      def evil?(req)
        (req.path && paths.any? { |matcher| match?(req.path, matcher) }) ||
        (req.query_string && queries.any? { |matcher| match?(req.query_string, matcher) }) ||
        (checks.any? { |matcher| match?(req, matcher) })
      end
      
      def template
        Pathname.new(__FILE__).dirname.join('..', '..', '..', 'templates', 'shield.html')
      end
  
      private
  
      def match?(obj, matcher)
        case matcher
        when String then obj.include?(matcher)
        when Regexp then obj.match?(matcher)
        when Proc   then matcher.call(obj)
        end
      end
    end

    self.paths     = DEFAULT_PATHS.dup
    self.queries   = DEFAULT_QUERIES.dup
    self.checks    = []
    self.response  = Response
    
  end
end
