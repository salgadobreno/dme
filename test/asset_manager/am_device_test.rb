require 'test_helper'

describe AmDevice do
  it 'has a Serial Number, Warranty Days & Sold At' do
    AmDevice.new 333, 365, Date.today
  end

end
