require 'rack'
require 'json'
module Rack
  class JsonCommonLogger < Rack::CommonLogger
    private
    def log(env, status, header, began_at)
      msg = JsonLogFormatter.new(env, header, status, began_at).to_json
      logger = @logger || env['rack.errors']
      logger.respond_to?(:write) ? logger.write(msg) : logger << msg
    end
  end

  # Formats request log from rack env to json
  class JsonLogFormatter
    def initialize(env, headers, status, began_at)
      @env = env
      @began_at = began_at
      @status = status
      @headers = headers
    end

    def to_json
      "#{message.to_json}\n"
    end

    def message
      now = Time.now.utc
      {
        timestamp: now.strftime('%Y-%m-%dT%H:%M:%SZ'),
        method: env[REQUEST_METHOD],
        remote_address: remote_address,
        location: location,
        params: (env['rack.request.form_hash'] || {}),
        query_string: query_string,
        status: status.to_s[0..3],
        length: extract_content_length,
        duration: (now - began_at)
      }
    end

    private

    def extract_content_length
      value = headers[CONTENT_LENGTH] or return '-'
      value.to_s == '0' ? '-' : value
    end

    def remote_address
      env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-"
    end

    def query_string
      env[QUERY_STRING].empty? ? '' : "?#{env[QUERY_STRING]}"
    end

    def location
      "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['PATH_INFO']}"
    end

    attr_accessor :env, :headers, :status, :began_at
  end
end
