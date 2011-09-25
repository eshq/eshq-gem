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
    assert_equal "http://example.com", client.url
    assert_equal "key", client.key
    assert_equal "secret", client.secret
  end

  def test_caches_client
    ESHQ::Client.expects(:new).once.returns(stub(:client))
    2.times { ESHQ.client }
  end

  def test_missing_settings
    ENV["ESHQ_KEY"] = nil
    begin
      ESHQ.client
      flunk "No exception raised"
    rescue => e
      assert_match /Missing environment variable/, e.to_s
    end
  end

  def test_open_socket
    ESHQ.client.expects(:post).with("/socket", {:channel => "test"}).returns({"socket_id" => "12345"})
    assert_equal "12345", ESHQ.open_socket(:channel => "test")
  end

  def test_event
    ESHQ.client.expects(:post).with("/event", :channel => "test", :data => "Testing", :type => "test-event")
    ESHQ.send_event(:channel => "test", :data => "Testing", :type => "test-event")
  end
end
