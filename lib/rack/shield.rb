require 'pathname'
require 'stringio'
require 'rack/attack'
require_relative 'shield/version'
require_relative 'shield/responder'
require_relative 'shield/request_ext'

module Rack
  module Shield
    DEFAULT_PATHS = [/\/wp-(includes|content|admin|json|config)/,
                     /\.(php\d?|cgi|asp|aspx|shtml|log|(my)?sql(\.tar)?(\.t?(gz|zip))?|cfm|cmd|py|lasso|e?rb|pl|jsp|do|action|sh|dll|lsp)\z/i,
                    'cgi-bin',
                    'phpmyadmin',
                    '/pma/',
                    '/boaform/',
                    'sqlbuddy',
                    /(my)?sql-backup/,
                    'etc/passwd',
                    '/php/',
                    '.php/',
                    '/browsedisk',
                    '/mambo/',
                    '/ipython/',
                    '/jenkins/',
                    '/joomla/',
                    '/varien/js.js',
                    '/drupal.js',
                    'RELEASE_NOTES.txt',
                    '/phpunit/',
                    '/magento/',
                    '/mage/',
                    '/magento_version',
                    '/mifs/',
                    '/js/varien/',
                    '/includes/',
                    '/HNAP1',
                    '/stalker_portal/',
                    '/nmaplowercheck',
                    '/solr/admin/',
                    '/axis2/axis2-admin',
                    '/telescope/requests',
                    '/RELEASE_NOTES.txt',
                    'deployment-config.json',
                    'ftpsync.settings',
                    '/_profiler/latest',
                    '/_ignition/',
                    '/_wpeprivate/',
                    '/Config/SaveUploadedHotspotLogoFile',
                    'ALFA_DATA',
                    'cgialfa',
                    'alfacgiapi',
                    '/+CSCOT+/',
                    '/api/v2/cmdb/system',
                    'com.vmware.vsan.client.services',
                    '/aspnet-ajax/',
                    '/Portal.mwsl',
                    '/adminer',
                    '/appsuite/signin',
                    '/io.ox/',
                    '/tkset/',
                    '/bakula-web',
                    '/snort/',
                    '/officescan/',
                    '/servlet/',
                    '/ox6/',
                    '/ws_utc/',
                    '/OASREST/',
                    '/WEB-INF/',
                    '/faspex/',
                    '/(download)/',
                    '/nacos/',
                    '/UploadServlet',
                    '/meta-data/identity-credentials/',
                    '/SDK/webLanguage',
                    /\A\/"/,
                    /\/\.(hg|git|svn|bzr|htaccess|ftpconfig|vscode|remote-sync|aws|env|DS_Store)/,
                    /\/old\/?\z/,
                    /\/\.env\z/,
                    /\A\/old-wp/,
                    /\A\/(wordpress|wp)(\/|\z)/,
                    /Open-Xchange/i]
    
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
                       'phpstorm',
                       '<php>',
                       'onload=confirm',
                       'HelloThinkCMF',
                       'XDEBUG_SESSION_START']
    
    DEFAULT_BODIES = ['OKMLlKlV']
    
    class << self

      attr_accessor :paths, :queries, :bodies, :checks, :responder
  
      def evil?(req)
        evil_paths?(req) || evil_queries?(req) || evil_checks?(req) || evil_bodies?(req)
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
      
      def evil_paths?(req)
        req.path && paths.any? { |matcher| match?(req.path, matcher) }
      end
      
      def evil_queries?(req)
        req.query_string && queries.any? { |matcher| match?(req.query_string, matcher) }
      end
      
      def evil_checks?(req)
        checks.any? { |matcher| match?(req, matcher) }
      end
      
      def evil_bodies?(req)
        return false unless req.post? || req.put? || req.patch?
        return false unless body = req.raw_post_data
        return false if body.empty?
        bodies.any? { |matcher| match?(body, matcher) }
      end
    end

    self.paths     = DEFAULT_PATHS.dup
    self.queries   = DEFAULT_QUERIES.dup
    self.bodies    = DEFAULT_BODIES.dup
    self.checks    = []
    self.responder = Responder

  end
end
