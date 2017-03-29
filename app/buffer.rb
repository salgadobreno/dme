require 'irb'

class Buffer
  attr_reader :devices

  def initialize(list = [])
    @devices = setup_list list
  end

  def send_forward
    list = @devices.values.flatten

    list.each &:forward

    @devices = setup_list list
  end

  def add device
    #TODO: fix
    @devices = setup_list(@devices.values.flatten << device)
  end

  def rm device
    devices_arr = @devices.values.flatten
    devices_arr.delete device
    @devices = setup_list devices_arr
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
