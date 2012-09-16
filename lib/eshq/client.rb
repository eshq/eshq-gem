require "digest/sha1"
require "net/http"
require "uri"
require "multi_json"

module ESHQ
  class Client
    def initialize
      ESHQ.configure
    end

    def config
      ESHQ.configuration
    end

    def post(path, params)
      url = url_for(path)

      request = Net::HTTP::Post.new(url.path)
      request.set_form_data(params.merge(credentials))

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.is_a?(URI::HTTPS)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      response = http.request(request)
      if response.code == "200"
        response.content_type == "application/json" ? MultiJson.load(response.body) : true
      else
        raise "Error #{response.body}"
      end
    end

    def credentials
      time = Time.now.to_i.to_s
      {:key => config.key, :timestamp => time, :token => token(time)}
    end

    def token(time)
      Digest::SHA1.hexdigest([config.key, config.secret, time].join(":"))
    end

    def url_for(path)
      URI.parse(config.url).tap do |url|
        url.path = path
      end
    end
  end
end
