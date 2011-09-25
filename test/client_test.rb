require "test/unit"
require "mocha"
require "timecop"
require "digest/sha1"
require "net/http"

require "eshq/client"

class TestClient < Test::Unit::TestCase
  attr_reader :client

  def setup
    @client = ESHQ::Client.new("http://example.com", "key", "secret")
  end

  def test_post
    Net::HTTP.expects(:post_form).with() { |uri, params|
      uri.to_s == "http://example.com/socket" &&
      params.keys.sort == [:presence_id, :timestamp, :token]
    }.returns('{"socket_id": "12345"}')
    res = client.post("/socket", :presence_id => "Mathias")
    assert_equal "12345", res["socket_id"]
  end

  def test_credentials
    t    = Time.now
    hash = Digest::SHA1.hexdigest("key:secret:#{t.to_i}")
    Timecop.freeze(t) do
      assert_equal({:timestamp => t.to_i.to_s, :token => hash}, client.credentials)
    end
  end
end
