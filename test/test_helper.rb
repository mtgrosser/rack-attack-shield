require 'pathname'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'minitest/autorun'
require 'debug'

module Minitest
  module Declarative
    def test(name, &block)
      test_name = "test_#{name.gsub(/\s+/, '_')}".to_sym
      defined = method_defined? test_name
      raise "#{test_name} is already defined in #{self}" if defined
      if block_given?
        define_method(test_name, &block)
      else
        define_method(test_name) do
          flunk "No implementation provided for #{name}"
        end
      end
    end
  end
end

Minitest::Test.extend Minitest::Declarative

class TestRequest
  include Rack::Shield::RequestExt
  
  attr_reader :path, :query_string, :content_type, :method, :body
  
  def initialize(path, query_string: nil, content_type: nil, method: :get, body: nil)
    @path, @query_string, @content_type, @method = path, query_string, content_type, method
    @env = { 'REQUEST_METHOD' => method.to_s.upcase, 'REQUEST_URI' => path }
    @body = StringIO.new(body) if body && %i[post put patch].include?(method)
  end
  
  def env
    @env
  end
  
  %i[head get post put patch delete].each do |http_method|
    define_method("#{http_method}?") { method == http_method }
  end
end
