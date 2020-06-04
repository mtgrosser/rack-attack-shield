require 'pathname'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'minitest/autorun'

class TestRequest
  attr_reader :path, :query_string
  
  def initialize(path, query_string = nil)
    @path, @query_string = path, query_string
  end
end
