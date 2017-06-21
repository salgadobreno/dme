require 'irb'

class Buffer

  def initialize(list = [])
    @devices = list
  end

  def devices
    setup_list @devices
  end

  def send_forward
    @devices.each &:forward
  end

  def add device
    @devices << device
  end

  def rm device
    @devices.delete device
  end

  private

  def setup_list(list)
    h_list = {}

    for device in list
      curr_state = device.current_state.name.to_sym

      h_list[curr_state] ||= []
      h_list[curr_state] << device
    end
    h_list
  end
end
