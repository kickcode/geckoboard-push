require 'minitest/autorun'
gem 'fakeweb'
require 'fakeweb'
gem 'mocha'
require 'minitest/unit'
require 'mocha/mini_test'
require File.join(File.expand_path(File.dirname(__FILE__)), "..", "..", "lib", "geckoboard", "push")

class PushTest < MiniTest::Unit::TestCase
  def setup
    FakeWeb.allow_net_connect = false
    @api_key = "12345"
    @widget_key = "54321"
  end

  def test_with_no_api_key
    assert_raises Geckoboard::Push::Error do
      Geckoboard::Push.new(nil, @widget_key).number_and_secondary_value(100, 10)
    end
  end

  def test_invalid_key
    response = Net::HTTPOK.new("1.1", 200, "OK")
    response.instance_variable_set(:@body, '{"success":false,"error":"Api key has wrong format."}')
    response.instance_variable_set(:@read, true)
    Net::HTTP.any_instance.expects(:request).returns(response)
    assert_raises(Geckoboard::Push::Error, "Api key has wrong format.") do
      Geckoboard::Push.new("invalid", @widget_key).number_and_secondary_value(100, 10)
    end
  end

  def test_invalid_api_key_with_new_error_location
    response = Net::HTTPOK.new("1.1", 401, "Unauthorized")
    response.instance_variable_set(:@body, '{"message":"Your API key is invalid"}')
    response.instance_variable_set(:@read, true)
    Net::HTTP.any_instance.expects(:request).returns(response)
    assert_raises(Geckoboard::Push::Error, "Your API key is invalid") do
      Geckoboard::Push.new("invalid", @widget_key).number_and_secondary_value(100, 10)
    end
  end

  def test_number_and_secondary_value
    expect_http_request({"api_key" => "12345", "data" => {"item" => [{"text" => "", "value" => 100}, {"text" => "", "value" => 10}]}}.to_json)
    assert_equal true, Geckoboard::Push.new(@api_key, @widget_key).number_and_secondary_value(100, 10)
  end

  def test_text
    expect_http_request({"api_key" => "12345", "data" => {"item" => [{"text" => "Test1", "type" => 2}, {"text" => "Test2", "type" => 1}]}}.to_json)
    assert_equal true, Geckoboard::Push.new(@api_key, @widget_key).text([{:type => :info, :text => "Test1"}, {:type => :alert, :text => "Test2"}])
  end

  def test_rag
    expect_http_request({"api_key" => "12345", "data" => {"item" => [{"value" => 1}, {"value" => 2}, {"value" => 3}]}}.to_json)
    assert_equal true, Geckoboard::Push.new(@api_key, @widget_key).rag(1,2,3)
  end

  def test_line
    expect_http_request({"api_key" => "12345", "data" => {"item" => [1,2,3], "settings" => {"axisx" => "x axis", "axisy" => "y axis", "colour" => "ff9900"}}}.to_json)
    assert_equal true, Geckoboard::Push.new(@api_key, @widget_key).line([1,2,3], "ff9900", "x axis", "y axis")
  end

  def test_pie
    expect_http_request({"api_key" => "12345", "data" => {"item" => [{"value" => 1, "label" => "Test1", "colour" => "ff9900"}, {"value" => 2, "label" => "Test2", "colour" => "ff0099"}]}}.to_json)
    assert_equal true, Geckoboard::Push.new(@api_key, @widget_key).pie([{:value => 1, :label => "Test1", :colour => "ff9900"}, {:value => 2, :label => "Test2", :colour => "ff0099"}])
  end

  def test_geckometer
    expect_http_request({"api_key" => "12345", "data" => {"item" => 100, "min" => {"value" => 50}, "max" => {"value" => 200}}}.to_json)
    assert_equal true, Geckoboard::Push.new(@api_key, @widget_key).geckometer(100, 50, 200)
  end

  def test_funnel
    expect_http_request({"api_key" => "12345", "data" => {"item" => [{"value" => 5, "label" => "Test1"}, {"value" => 10, "label" => "Test2"}], "type" => "reverse", "percentage" => "hide"}}.to_json)
    assert_equal true, Geckoboard::Push.new(@api_key, @widget_key).funnel([{:label => "Test1", :value => 5}, {:label => "Test2", :value => 10}], true, true)
  end

  def expect_http_request(json)
    response = Net::HTTPOK.new("1.1", 200, "OK")
    response.instance_variable_set(:@body, '{"success":true}')
    response.instance_variable_set(:@read, true)
    Net::HTTP.any_instance.expects(:request).with do |request|
      assert_equal json, request.body
      request.path == "/v1/send/54321" && request.method == "POST" && request.body == json
    end.returns(response)
  end
end
