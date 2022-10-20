require "webrick/httputils"

module Digdag
  module Request
    def get(path, options={})
      request(:get, path, options)
    end

    def post(path, options={})
      request(:post, path, options)
    end

    def put(path, options={})
      request(:put, path, options)
    end

    def delete(path, options={})
      request(:delete, path, options)
    end

    private
    def request(method, path, options)
      response = connection.send(method) do |request|
        path = "/api/#{path}"
        case method
        when :get, :delete
          request.url(WEBrick::HTTPUtils.escape(path), options)
        when :post, :put
          if method == :post
            request.headers['Content-Type'] = 'application/json'
          end
          request.path = WEBrick::HTTPUtils.escape(path)
          request.body = options unless options.empty?
        end
      end

      response.body
    end
  end
end
