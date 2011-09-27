require "digest/sha1"
require "net/http"
require "uri"
require "json"

module ESHQ
  class Client
    attr_reader :url, :key, :secret

    def initialize(url, api_key, api_secret)
      @url        = url
      @key    = api_key
      @secret = api_secret
    end

    def post(path, params)
      response = Net::HTTP.post_form(url_for(path), params.merge(credentials))
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
