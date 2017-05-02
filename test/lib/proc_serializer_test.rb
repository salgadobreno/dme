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

  describe "bugs" do
    let(:nonbug) {
      lambda { |x|
        if x[:index].even?
          true
        else
          x[:error] = 'Valor não é par:' + x[:index].to_s
          false
        end
      }
    }
    let(:bug) {
      lambda { |x|
        if x[:index].even?
          true
        else
          x[:error] = "Valor não é par:" + x[:index].to_s
          false
        end
      }
    }
    let(:bug2) {
      lambda { |x|
        x[:error] = "teste"
      }
    }
    let(:nonbug2) {
      lambda { |x|
        x[:error] = 'teste'
      }
    }

    #NOTE: trying to register problems with the very old sourcify,
    #we can change implementation to other options if necessary:
    #ruby2ruby, seattlerb/ruby_parser, whitequark/parser
    it 'bugs predictably' do
      proc { ProcSerializer.new(bug).to_source }.must_raise Exception
      proc { ProcSerializer.new(bug2).to_source }.must_raise Exception
      ProcSerializer.new(nonbug).to_source #no error
      ProcSerializer.new(nonbug2).to_source #no error
    end

  end
end
