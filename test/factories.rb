FactoryGirl.define do
  factory :am_device do
    sequence :serial_number do |n|
      n
    end
    sold_at Date.today
    warranty_days 365
    blacklisted false

    initialize_with { new(serial_number, sold_at, warranty_days, blacklisted)}
  end

  factory :device_so do
    am_device
    state_machine DefaultStateMachine.new

    initialize_with { new(am_device, state_machine)}
  end
end
