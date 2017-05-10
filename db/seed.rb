require 'dashboard_init'

today = Date.today
data = [
  [111,  today, 365],
  [222,  today, 365],
  [333,  today, 365],
  [444,  today, 365],
  [555,  today, 365],
  [666,  today, 365],
  [777,  today, 365],
  [888,  today, 365],
  [999,  today, 365],
  [000,  today, 365]
]

data.each {|d|
  AmDevice.new(*d).save!
}
