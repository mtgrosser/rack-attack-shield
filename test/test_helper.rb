require 'pathname'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'minitest/autorun'

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
  attr_reader :path, :query_string
  
  def initialize(path, query_string = nil)
    @path, @query_string = path, query_string
  end
end
