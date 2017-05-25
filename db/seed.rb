require 'dashboard_init'

today = Date.today
data = [
  [111,  today, 365, true],
  [222,  today, 365, false],
  [333,  today, 365, false],
  [444,  today, 365, false],
  [555,  today, 365, false],
  [666,  today, 365, false],
  [777,  today, 365, false],
  [888,  today, 365, false],
  [999,  today, 365, false],
  [000,  today, 365, false]
]

data.each {|d|
  AmDevice.new(*d).save!
}
