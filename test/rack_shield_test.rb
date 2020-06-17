require_relative 'test_helper'

class RackShieldTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Rack::Shield::VERSION
  end

  def test_wordpress_is_blocked
    assert Rack::Shield.evil?(TestRequest.new('/wp-admin'))
  end
  
  def test_cgi_ext_is_blocked
    assert Rack::Shield.evil?(TestRequest.new('/foo/bar.cgi'))
  end
  
  def test_head_returns_empty_body
    status, _, body = Rack::Shield::Response.new({'REQUEST_METHOD' => 'HEAD', 'REQUEST_URI' => '/site.html'}).render
    assert_equal 403, status
    assert_empty body
  end
end
