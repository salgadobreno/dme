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

  it 'should serialize an Operation/Validation successfully' do
    class TestOperation < State::Operation
      def call payload
        payload[:teste] ||= 0
        payload[:teste] += 1
      end
    end

    class TestValidation < State::Validation
      def call payload
        payload[:teste_v] ||= 0
        payload[:teste_v] += 1
      end
    end

    to = TestOperation.new
    tv = TestValidation.new

    payload = {}

    to.call payload
    tv.call payload

    payload[:teste].must_equal 1
    payload[:teste_v].must_equal 1

    to_serialized = ProcSerializer.new(to).serialize
    tv_serialized = ProcSerializer.new(tv).serialize

    to_restored = ProcSerializer.new(to_serialized).restore
    tv_restored = ProcSerializer.new(tv_serialized).restore

    to_restored.call payload
    tv_restored.call payload

    payload[:teste].must_equal 2
    payload[:teste_v].must_equal 2
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

    it 'bugs predictably' do
      proc { ProcSerializer.new(bug).to_source }.must_raise Exception
      proc { ProcSerializer.new(bug2).to_source }.must_raise Exception
      ProcSerializer.new(nonbug).to_source #no error
      ProcSerializer.new(nonbug2).to_source #no error
    end

  end
end
