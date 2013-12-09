require 'test/unit'
gem 'fakeweb'
require 'fakeweb'
gem 'mocha'
require 'mocha'
require File.join(File.expand_path(File.dirname(__FILE__)), "..", "..", "lib", "geckoboard", "push")

class PushTest < Test::Unit::TestCase
  def setup
    FakeWeb.allow_net_connect = false
    Geckoboard::Push.api_key = "12345"
    @push = Geckoboard::Push.new("54321")
  end

  def test_with_no_api_key
    Geckoboard::Push.api_key = nil
    assert_raise Geckoboard::Push::Error do
      @push.number_and_secondary_value(100, 10)
    end
  end

  def test_invalid_key
    Geckoboard::Push.api_key = "invalid"
    response = Net::HTTPOK.new("1.1", 200, "OK")
    response.instance_variable_set(:@body, '{"success":false,"error":"Api key has wrong format. "}')
    response.instance_variable_set(:@read, true)
    Net::HTTP.any_instance.expects(:request).returns(response)
    assert_raise Geckoboard::Push::Error do
      @push.number_and_secondary_value(100, 10)
    end
  end

  def test_number_and_secondary_value
    expect_http_request({"api_key" => "12345", "data" => {"item" => [{"text" => "", "value" => 100}, {"text" => "", "value" => 10}]}}.to_json)
    assert_equal true, @push.number_and_secondary_value(100, 10)
  end

  def test_text
    expect_http_request({"api_key" => "12345", "data" => {"item" => [{"text" => "Test1", "type" => 2}, {"text" => "Test2", "type" => 1}]}}.to_json)
    assert_equal true, @push.text([{:type => :info, :text => "Test1"}, {:type => :alert, :text => "Test2"}])
  end

  def test_rag
    expect_http_request({"api_key" => "12345", "data" => {"item" => [{"value" => 1}, {"value" => 2}, {"value" => 3}]}}.to_json)
    assert_equal true, @push.rag(1,2,3)
  end

  def test_line
    expect_http_request({"api_key" => "12345", "data" => {"item" => [1,2,3], "settings" => {"axisx" => "x axis", "axisy" => "y axis", "colour" => "ff9900"}}}.to_json)
    assert_equal true, @push.line([1,2,3], "ff9900", "x axis", "y axis")
  end

  def test_pie
    expect_http_request({"api_key" => "12345", "data" => {"item" => [{"value" => 1, "label" => "Test1", "colour" => "ff9900"}, {"value" => 2, "label" => "Test2", "colour" => "ff0099"}]}}.to_json)
    assert_equal true, @push.pie([{:value => 1, :label => "Test1", :colour => "ff9900"}, {:value => 2, :label => "Test2", :colour => "ff0099"}])
  end

  def test_geckometer
    expect_http_request({"api_key" => "12345", "data" => {"item" => 100, "min" => {"value" => 50}, "max" => {"value" => 200}}}.to_json)
    assert_equal true, @push.geckometer(100, 50, 200)
  end

  def test_funnel
    expect_http_request({"api_key" => "12345", "data" => {"item" => [{"value" => 5, "label" => "Test1"}, {"value" => 10, "label" => "Test2"}], "type" => "reverse", "percentage" => "hide"}}.to_json)
    assert_equal true, @push.funnel([{:label => "Test1", :value => 5}, {:label => "Test2", :value => 10}], true, true)
  end

  def test_highcharts

    expect_http_request({"api_key" => "12345", "data" => {"highchart" => { "chart" => {renderTo: 'container'}, credits: {enabled: false}, series: [{name: 'ABC', data: [1,2,3]}, {name: 'DEF', data: [4,5,6]}], yAxis: { title: {text: "LABEL"} }}}}.to_json)
    assert_equal true, @push.highchart([{name: 'ABC', data: [1,2,3]}, {name: 'DEF', data: [4,5,6]}], {yAxis: {title: {text: "LABEL"}} })
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
