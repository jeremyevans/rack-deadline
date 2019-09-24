require 'rubygems'
ENV['MT_NO_PLUGINS'] = '1' # Work around stupid autoloading of plugins
require 'minitest/global_expectations/autorun'

require 'rack/test'
require 'rack-deadline'

describe Rack::Session::Deadline do
  include Rack::Test::Methods

  attr_reader :app

  def request
    Rack::MockRequest.new(@app).get('').body
  end
  
  def time_class(&block)
    Class.new do
      define_method(:now) do
        Class.new do
          define_method(:to_i, &block)
        end.new
      end
    end.new
  end
  
  def deadline(opts={})
    @app = Rack::Session::Cookie.new(Rack::Session::Deadline.new(@app, opts), :secret=>'1')
  end

  before do
    @app = lambda do |env|
      old = env['rack.session']['foo']
      new = env['rack.session']['foo'] = (old||0) + 1
      [200, {'Content-Type'=>'text/html'}, ["#{old}=>#{new}"]]
    end
  end

  it "should work correctly with no options" do
    deadline
    get('/').body.must_equal '=>1'
    get('/').body.must_equal '1=>2'
    get('/').body.must_equal '2=>3'
  end

  it "should clear session if deadline is passed" do
    i = 0
    deadline(:deadline=>1, :time_class=>time_class{i})
    get('/').body.must_equal '=>1'
    get('/').body.must_equal '1=>2'
    i = 2
    get('/').body.must_equal '=>1'
    get('/').body.must_equal '1=>2'
    i = 4
    get('/').body.must_equal '=>1'
    get('/').body.must_equal '1=>2'
    get('/').body.must_equal '2=>3'
    i = 6
    get('/').body.must_equal '=>1'
  end

  it "should store deadline in given session key" do
    i = 5
    deadline(:key=>'foo', :time_class=>time_class{i})
    get('/').body.must_equal '=>1'
    i = 0
    get('/').body.must_equal '1=>2'
    get('/').body.must_equal '2=>3'
    get('/').body.must_equal '3=>4'
    get('/').body.must_equal '4=>5'
    get('/').body.must_equal '5=>6'
    i = 86407
    get('/').body.must_equal '=>1'
  end
end
