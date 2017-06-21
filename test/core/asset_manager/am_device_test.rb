require 'test_helper'

describe AmDevice do
  it 'has a Serial Number, Warranty Days, Sold At & Blacklisted' do
    AmDevice.new 333, Date.today, 365, false
  end
end
