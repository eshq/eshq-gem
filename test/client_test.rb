require "test/unit"
require "mocha"
require "timecop"
require "digest/sha1"
require "fakeweb"

require "eshq"

class TestClient < Test::Unit::TestCase
  attr_reader :client

  def setup
    ESHQ.configure do |config|
      config.url = 'http://example.com'
      config.key = 'key'
      config.secret = 'secret'
    end
    @client = ESHQ::Client.new
  end

  def test_post
    FakeWeb.register_uri(:post, "http://example.com/socket",
      :body => '{"socket": "12345"}',
      :content_type => "application/json"
    )

    res = client.post("/socket", :presence_id => "Mathias")
    assert_equal "12345", res["socket"]
  end

  def test_credentials
    t    = Time.now
    hash = Digest::SHA1.hexdigest("key:secret:#{t.to_i}")
    Timecop.freeze(t) do
      assert_equal({:key => "key", :timestamp => t.to_i.to_s, :token => hash}, client.credentials)
    end
  end
end
