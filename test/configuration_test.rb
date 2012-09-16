require "test/unit"
require "mocha"

require "eshq"

class TestConfiguration < Test::Unit::TestCase
  attr_reader :client

  def setup
    @client = ESHQ.client
  end

  def teardown
    ESHQ.reset_client
  end

  def test_defaults
    assert_equal "https://app.eventsourcehq.com/", ESHQ.configuration.url
  end

  def test_configure_url
    ESHQ.configure do |config|
      config.url = "http://example.com"
    end
    assert_equal "http://example.com", ESHQ.configuration.url
  end

  def test_configure_key
    ESHQ.configure do |config|
      config.key = "key"
    end
    assert_equal "key", ESHQ.configuration.key
  end

  def test_configure_secret
    ESHQ.configure do |config|
      config.secret = "secret"
    end
    assert_equal "secret", ESHQ.configuration.secret
  end

  def test_initializes_with_env_variables_when_available
    ENV["ESHQ_URL"] = "http://fallback.example.com"
    ENV["ESHQ_KEY"] = "fallback-key"
    ENV["ESHQ_SECRET"] = "fallback-secret"
    ESHQ.reset_client
    ESHQ.client
    assert_equal "http://fallback.example.com", ESHQ.configuration.url
    assert_equal "fallback-key", ESHQ.configuration.key
    assert_equal "fallback-secret", ESHQ.configuration.secret
  end
end

