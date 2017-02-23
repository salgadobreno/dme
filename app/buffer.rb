class Buffer
  attr_reader :items

  def initialize(list)
    @items = setup_list list
  end

  def send_forward
    list = @items.values.flatten

    list.each &:forward

    @items = setup_list list
  end

  private

  def setup_list(list)
    h_list = {}

    for item in list
      curr_state = item.current_state.name.to_sym

      h_list[curr_state] ||= []
      h_list[curr_state] << item
    end
    h_list
  end
end
