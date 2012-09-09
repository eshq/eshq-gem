require "digest/sha1"
require "net/http"
require "uri"
require "json"

module ESHQ
  class Client
    attr_reader :url, :key, :secret

    def initialize(url, api_key, api_secret)
      puts "NEW"
      @url        = url
      @key    = api_key
      @secret = api_secret
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
       response.content_type == "application/json" ? JSON.parse(response.body) : true
      else
        raise "Error #{response.body}"
      end
    end

    def credentials
      time = Time.now.to_i.to_s
      {:key => key, :timestamp => time, :token => token(time)}
    end

    def token(time)
      Digest::SHA1.hexdigest([key, secret, time].join(":"))
    end

    def url_for(path)
      URI.parse(url).tap do |url|
        url.path = path
      end
    end
  end
end
