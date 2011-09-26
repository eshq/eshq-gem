require "eshq/version"
require "eshq/client"

module ESHQ
  def self.client
    @@client ||= Client.new(*settings)
  end

  def self.reset_client
    @@client = nil
  end

  def self.open(options)
    client.post("/socket", options)["socket"]
  end

  def self.send(options)
    client.post("/event", options)
  end

  private
  def self.settings
    ["ESHQ_URL", "ESHQ_KEY", "ESHQ_SECRET"].map { |v|
      ENV[v] || raise("Missing environment variable #{v}")
    }
  end
end
