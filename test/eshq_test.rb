require "test/unit"
require "mocha"

require "eshq"

class TestESHQ < Test::Unit::TestCase
  def setup
    ESHQ.reset_client
    ENV["ESHQ_URL"]    = "http://example.com"
    ENV["ESHQ_KEY"]    = "key"
    ENV["ESHQ_SECRET"] = "secret"
  end

  def test_client_instantiation
    client = ESHQ.client
    assert_equal "http://example.com", client.config.url
    assert_equal "key", client.config.key
    assert_equal "secret", client.config.secret
  end

  def test_caches_client
    ESHQ::Client.expects(:new).once.returns(stub(:client))
    2.times { ESHQ.client }
  end

  def test_open
    ESHQ.client.expects(:post).with("/socket", {:channel => "test"}).returns({"socket" => "12345"})
    assert_equal "12345", ESHQ.open(:channel => "test")
  end

  def test_send
    ESHQ.client.expects(:post).with("/event", :channel => "test", :data => "Testing", :type => "test-event")
    ESHQ.send(:channel => "test", :data => "Testing", :type => "test-event")
  end
end
