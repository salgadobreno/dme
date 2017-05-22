require 'dashboard_init'

class WarrantyCheckValidation < State::Validation
  def call(payload, device)
    #NOTE: should this go through payload or device? Originally we planned to
    #data into the payload, but now we have a device param...
    warranty_days = device.warranty_days
    sold_at = device.sold_at
    now = DateTime.now

    in_warranty = (now - sold_at).to_i <= warranty_days

    payload[:warranted] = in_warranty

    device.device_logs << DeviceLog.new(device, "Device in warranty: #{in_warranty}")
    #TODO: I'd like to have a method for device which would shortcut the
    #`device.device_logs << DeviceLog.new(device...` part
    return payload[:warranted]
  end
end

class BlacklistValidation < State::Validation
  def call(payload, device)
    if device.blacklisted
      device.device_logs << DeviceLog.new(device, "Device is blacklisted!")
    end

    return !device.blacklisted # se blacklisted, invalido
  end
end
