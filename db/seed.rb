require 'dashboard_init'

today = Date.today
data = [
  [1,  today, 365],
  [2,  today, 365],
  [3,  today, 365],
  [4,  today, 365],
  [5,  today, 365],
  [6,  today, 365],
  [7,  today, 365],
  [8,  today, 365],
  [9,  today, 365],
  [10, today, 365]
]

data.each {|d|
  AMDevice.new(*d).save!
}
