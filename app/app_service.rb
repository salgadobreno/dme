require 'dashboard_init'

class AppService
  def add(serial_number)
    am_device = AmDevice.find_by(serial_number: serial_number)
    if DeviceSo.where(am_device: am_device).active.any?
      #já está no lab
      {
        message: "Device already in lab"
      }
    else
      state_machine = DefaultStateMachine.new
      device = DeviceSo.new am_device, state_machine
      device.save!
      {}
    end
  end

  def fw(serial_number)
    device = find_device serial_number

    # forwards device
    success = device.forward
    device.save!

    {
      success: success,
      has_next: !(device.current_state == StateMachine::SEGREGATED_STATE || device.finished)
    }
  end

  def rm(serial_number)
    # rm device
    device = find_device serial_number
    device.destroy
  end

  def show(serial_number)
    device = find_device serial_number
    am_device = device.am_device #grab the AssetManagerDevice because we want the full history

    {
      device: device,
      device_logs: am_device.device_logs
    }
  end

  def list
    devices = DeviceSo.active

    {
      devices: devices
    }
  end

  private

  def find_device serial_number
    am_device = AmDevice.find_by serial_number: serial_number.to_i
    device = am_device.device_sos.last
    raise Exception.new "Could not find device #{serial_number}" if device.nil?

    device
  end
end
