require_relative 'test_helper'

class RackShieldTest < Minitest::Test
  test 'Version' do
    refute_nil Rack::Shield::VERSION
  end

  test 'Wordpress is blocked' do
    assert_blocked '/wp-admin'
  end
  
  test 'Illegal file extensions are blocked' do
    ['/foo/bar.cgi',
      '/foobar.mysql.tar',
      '/foo.sql',
      '/foo.mysql',
      '/../../etc/passwd',
      '/phpmyadmin',
      '/foo.mysql.zip',
      '/foo.sql.zip'
    ].each { |path| assert_blocked path }
  end
  
  test 'ZIP files are not blocked' do
    assert_not_blocked '/foo.bar.zip'
  end
  
  test 'SQL injection is blocked' do
    assert_blocked '/posts/new', 'author_id=95%27%20UNION%20ALL%20SELECT%20NULL%2CNULL%2CNULL--%20HDgn'
  end
  
  test 'HEAD returns empty body' do
    status, _, body = Rack::Shield::Response.new({'REQUEST_METHOD' => 'HEAD', 'REQUEST_URI' => '/site.html'}).render
    assert_equal 403, status
    assert_empty body
  end
  
  private
  
  def assert_blocked(path, query = nil)
    message = "Expected #{path.inspect} "
    message << "with query #{query.inspect} " if query
    message << "to be blocked, but wasn't"
    assert Rack::Shield.evil?(TestRequest.new(path, query)), message
  end
  
  def assert_not_blocked(path, query = nil)
    message = "Expected #{path.inspect} "
    message << "with query #{query.inspect} " if query
    message << "not to be blocked, but was"
    assert !Rack::Shield.evil?(TestRequest.new(path, query)), message
  end
end
