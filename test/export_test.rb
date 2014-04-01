require 'test_helper'
require "rack/test"

OUTER_APP = Rack::Builder.parse_file('test/dummy/config.ru').first

class ExportTest < ActionController::TestCase
  tests ApplicationController
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def body
    last_response.body
  end

  def content_type
    last_response.content_type
  end

  test "[OK] GET home" do
    get '/'
    assert body =~ /hello world/, body
    assert body =~ /table id=.+greentable_id.+/, body
    assert body !~ /window.print/, body
    assert content_type =~ /text\/html/
  end

  test "[OK] GET home - print" do
    get '/', :greentable_id => 'greentable_id', :greentable_export => 'print'
    assert body !~ /hello world/, body
    assert body =~ /table id=.+greentable_id.+/, body
    assert body =~ /window.print/, body
    assert content_type =~ /text\/html/
  end

  test "[OK] GET home - csv" do
    get '/', :greentable_id => 'greentable_id', :greentable_export => 'csv'
    assert body !~ /hello world/, body
    assert body !~ /table id=.+greentable_id.+/, body
    assert body !~ /window.print/, body
    assert content_type =~ /text\/csv/

    expected =<<-END
x,x+1,i,first?,last?,odd?,even?
100,101,0,true,false,true,false
101,102,1,false,false,false,true
102,103,2,false,true,true,false
footer td,colspan=2,,"I
                    contain
                a
                sub
                    table"
    END
    assert_equal expected, body
  end

end
