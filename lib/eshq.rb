require "eshq/version"
require "eshq/client"
require "eshq/configuration"

module ESHQ
  class << self
    attr_accessor :configuration
  end

  def self.client
    @@client ||= Client.new
  end

  def self.reset_client
    self.configuration = nil
    @@client = nil
  end

  def self.open(options)
    client.post("/socket", options)["socket"]
  end

  def self.send(options)
    client.post("/event", options)
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end
end
