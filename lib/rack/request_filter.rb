require "rack/request_filter/version"

module Rack
  class RequestFilter
    attr_reader :filters

    def initialize(app, &block)
      @app = app
      @filters = []
      instance_eval &block if block_given?
    end

    def call(env)
      request = Rack::Request.new(env)
      return filtered_response(request) if filters.any? { |b| b.call(env, request) }

      @app.call env
    end

    def filter(block)
      @filters << block if block
    end

    private
    def filtered_response(request)
      puts "########## filtered request #{request.request_method} #{request.path_info}"
      [200, {"Content-Type" => "text/plain"}, ["Response from request filter."]]
    end
  end
end
