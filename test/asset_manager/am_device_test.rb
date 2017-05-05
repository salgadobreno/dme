require 'test_helper'

describe AMDevice do
  it 'has a Serial Number, Warranty Days & Sold At' do
    AMDevice.new 333, 365, Date.today
  end

end
