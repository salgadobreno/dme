require 'test_helper'

describe "operations and validations" do
  let(:state_inicio) {
    State.new :inicio, {
      :operations => nil,
      :validations => nil
    }
  }
  let(:state_fim) {
    State.new :fim, {
      :operation => nil,
      :validation => nil
    }
  }
  let(:state_machine) {
    StateMachine.new [state_inicio, state_fim]
  }
  let(:am_device) { AmDevice.new 1234, DateTime.now, 365, false }

  describe WarrantyCheckValidation do
    let(:am_device) { AmDevice.new 1234, (DateTime.now - 6.months), 365, false }
    let(:device_in_warranty) {
      d = DeviceSo.new am_device, state_machine
      d.stubs(:warranty_days).returns(365)
      d
    }
    let(:device_out_warranty) {
      d = DeviceSo.new am_device, state_machine
      d.stubs(:warranty_days).returns(90)
      d
    }

    it 'registers when device is in/out of warranty' do
      state_w_warranty = State.new(:inicio, {validations: [WarrantyCheckValidation.new]})
      payload_warranty = {}
      payload_no_warranty = {}

      w_warranty_valid = state_w_warranty.validate(payload_warranty, device_in_warranty)
      wo_warranty_valid = state_w_warranty.validate(payload_no_warranty, device_out_warranty)

      payload_warranty[:warranted].must_equal true
      w_warranty_valid.must_equal true
      payload_no_warranty[:warranted].must_equal false
      wo_warranty_valid.must_equal false
      device_in_warranty.device_logs.size.must_equal 1
      device_in_warranty.device_logs.first.description.must_match /true/
      device_out_warranty.device_logs.size.must_equal 1
      device_out_warranty.device_logs.first.description.must_match /false/
    end
  end

  describe BlacklistValidation do
    let(:am_device) { AmDevice.new 1234, DateTime.now, 365, false }
    let(:device_so) {
      DeviceSo.new am_device, state_machine
    }
    let(:device_so_blacklisted) {
      ds = DeviceSo.new am_device, state_machine
      ds.stubs(:blacklisted).returns(true)
      ds
    }

    it 'validates a Blacklisted device' do
      state_w_blacklist = State.new(:inicio, {:validations => [BlacklistValidation.new]})

      state_w_blacklist.validate({}, device_so).must_equal true
      state_w_blacklist.validate({}, device_so_blacklisted).must_equal false
    end
  end
end
