require 'dashboard_init'

today = Date.today
data = [
  [111,  today, 365, true],
  [222,  today, 365, true],
  [333,  today, 365, true],
  [444,  today, 365, true],
  [555,  today, 365, true],
  [666,  today, 365, true],
  [777,  today, 365, true],
  [888,  today, 365, true],
  [999,  today, 365, true],
  [000,  today, 365, false]
]

data.each {|d|
  AmDevice.new(*d).save!
}
