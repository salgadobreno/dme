require 'dashboard_init'

class AppService

  def add(serial_number, payload = {})
    encapsulate_error do
      am_device = AmDevice.find_by serial_number: serial_number
      if am_device.nil?
        {
          success: false,
          message: "Serial Number: #{serial_number} did not match any Asset Manager Device."
        }
      else
        if DeviceSo.where(am_device: am_device).active.any?
          #já está no lab
          {
            success: false,
            message: "Device already in lab"
          }
        else
          state_machine = DefaultStateMachine.new(payload)
          device = DeviceSo.new am_device, state_machine
          device.save!
          {
            success: true
          }
        end
      end
    end
  end

  def fw(serial_number)
    encapsulate_error do
      device = find_device serial_number

      # forwards device
      #success = device.forward
      device.forward
      device.save!

      {
        success: true,
        has_next: !(device.current_state == StateMachine::SEGREGATED_STATE || device.finished)
        #TODO: has_next should be in model
      }
    end
  end

  def rm(serial_number)
    # rm device
    encapsulate_error do
      device = find_device serial_number
      device.destroy
      {
        success: true
      }
    end
  end

  def show(serial_number)
    encapsulate_error do
      device = find_device serial_number

      {
        success: true,
        data: device
      }
    end
  end

  def list
    devices = DeviceSo.active
    {
      success: true,
      data: devices
    }
  end

  def am_device_list
    am_devices = AmDevice.all
    {
      success: true,
      data: am_devices
    }
  end

  def show_log(serial_number)
    encapsulate_error do
      am_device = AmDevice.find_by serial_number: serial_number

      {
        success:true,
        data: am_device.device_logs
      }
    end
  end

  def run_seed
    encapsulate_error do
      load 'Rakefile'
      #NOTE: `reenable` is necessary because rake checks which tasks have already been executed,
      # in this case we always want it to run
      Rake::Task["db:db_config"].reenable
      Rake::Task["db:seed"].reenable
      Rake::Task["db:seed"].invoke
      {
        success: true
      }
    end
  end

  # The 'light seed' won't remove the DeviceLogs as requested by Felipe
  def run_light_seed
    encapsulate_error do
      DeviceSo.delete_all
      {
        success:true
      }
    end
  end

  def forward_all
    encapsulate_error do
      DeviceSo.active.each do |d|
        d.forward
        d.save!
      end
      {
        success:true
      }
    end
  end

  def run_complete
    encapsulate_error do
      DeviceSo.active.map(&:serial_number).each do |serial_number|
        r = fw(serial_number)
        while r[:has_next] do
          r = fw(serial_number)
        end
      end
      {
        success:true
      }
    end
  end

  def overview
    encapsulate_error do
      h = {}
      h.default = 0
      DeviceSo.active.map { |e| h[e.current_state.to_s.to_sym] += 1 }
      h.default = nil
      {
        data: h,
        success:true
      }
    end
  end

  def segregated_overview
    encapsulate_error do
      data = DeviceSo.active.segregated
      {
        data: data,
        success:true
      }
    end
  end

  private

  def encapsulate_error(&block)
    #TODO: theres probably a way to do this with more metaprogramming/less repeated code
    begin
      yield
    rescue Exception => e
      {
        success:false,
        message:e.message
      }
    end
  end

  def find_device serial_number
    am_device = AmDevice.find_by serial_number: serial_number
    raise AppException.new("Device not found") if am_device.nil?
    #TODO: device = am_device.device_sos.active.last ?
    #As it currently is, it could fetch a finished DeviceSo
    device = am_device.device_sos.last

    device
  end
end
