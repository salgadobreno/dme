require 'test_helper'
require 'lib/proc_serializer'

describe ProcSerializer do
  it "should serialize a proc or lambda successfully" do
    mock_obj = mock()
    mock_obj.expects(:call).times(4)

    prok = proc {|obj| obj.call }
    lamqda = lambda {|obj| obj.call }

    prok.call mock_obj
    lamqda.call mock_obj

    prok_source = ProcSerializer.new(prok).to_source
    lamqda_source = ProcSerializer.new(lamqda).to_source

    prok_recover = ProcSerializer.new(prok_source).from_source
    lamqda_recover = ProcSerializer.new(lamqda_source).from_source

    prok_recover.call mock_obj
    lamqda_recover.call mock_obj
  end
end
