module ESHQ
  class Configuration
    attr_accessor :url, :key, :secret

    def initialize
      @url = ENV["ESHQ_URL"] || 'https://app.eventsourcehq.com/'
      @key = ENV["ESHQ_KEY"]
      @secret = ENV["ESHQ_SECRET"]
    end
  end
end
