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
end
