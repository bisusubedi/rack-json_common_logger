require 'pry'
require 'rack'

require 'rack/lint'
require 'rack/mock'

require 'logger'
require 'rack/commonlogger'
require 'spec_helper'

describe Rack::JsonCommonLogger do
  obj = 'foobar'
  length = obj.size

  app = Rack::Lint.new lambda { |env|
    [200,
     {"Content-Type" => "text/html", "Content-Length" => length.to_s},
     [obj]]}
  app_without_length = Rack::Lint.new lambda { |env|
    [200,
     {"Content-Type" => "text/html"},
     []]}
  app_with_zero_length = Rack::Lint.new lambda { |env|
    [200,
     {"Content-Type" => "text/html", "Content-Length" => "0"},
     []]}

  it "log to rack.errors by default" do
    res = Rack::MockRequest.new(Rack::JsonCommonLogger.new(app)).get("/")
    expect(res.errors).not_to be_empty
    expect(res.errors).to match(/"method":"GET"/)
  end

  it "log to anything with +write+" do
    log = StringIO.new
    res = Rack::MockRequest.new(Rack::JsonCommonLogger.new(app, log)).get("/")
    expect(log.string).to match(/"method":"GET"/)
  end

  it "work with standartd library logger" do
    logdev = StringIO.new
    log = Logger.new(logdev)
    Rack::MockRequest.new(Rack::JsonCommonLogger.new(app, log)).get("/")
    expect(logdev.string).to match(/"method":"GET"/)
  end

  it "log - content length if header is missing" do
    res = Rack::MockRequest.new(Rack::JsonCommonLogger.new(app_without_length)).get("/")

    expect(res.errors).not_to be_empty
    expect(res.errors).to match(/"method":"GET"/)
  end

  it "log - content length if header is zero" do
    res = Rack::MockRequest.new(Rack::JsonCommonLogger.new(app_with_zero_length)).get("/")

    expect(res.errors).not_to be_empty
    expect(res.errors).to match(/"length":"-"/)
  end

  def with_mock_time(t = 0)
    mc = class << Time; self; end
    mc.send :alias_method, :old_now, :now
    mc.send :define_method, :now do
      at(t)
    end
    yield
  ensure
    mc.send :undef_method, :now
    mc.send :alias_method, :now, :old_now
  end

  it "log in json format" do
    log = StringIO.new
    with_mock_time do
      Rack::MockRequest.new(Rack::JsonCommonLogger.new(app, log)).get("/")
    end
    parsed_log = JSON.parse(log.string)
    expect(parsed_log.class).to eql(Hash)
    expect(parsed_log['timestamp']).to eql(Time.at(0).utc.strftime('%Y-%m-%dT%H:%M:%SZ'))
    expect(parsed_log['method']).to eql('GET')
    expect(parsed_log['status']).to eql('200')
    expect((0..1)).to include(parsed_log['duration'].to_f)
  end

  def length
    123
  end

  def self.obj
    "hello world"
  end
end