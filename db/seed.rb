require 'dashboard_init'

data = [
  [100000375,   Date.parse("18-Nov-2014"), 365],
  [100001377,   Date.parse("15-Sep-2014"), 365],
  [100001402,   Date.parse("10-Mar-2015"), 365],
  [100001489,   Date.parse("11-Mar-2015"), 365],
  [100001495,   Date.parse("21-Jan-2016"), 365],
  [100001541,   Date.parse("22-Jan-2016"), 365],
  [100001614,   Date.parse("23-Jan-2016"), 365],
  [100002524,   Date.parse("24-Jan-2016"), 365],
  [100002531,   Date.parse("5-May-2016"),  365],
  [100002534,   Date.parse("5-May-2016"),  365],
  [100000204,   Date.parse("6-May-2016"),  365],
  [100000537,   Date.parse("7-May-2016"),  365],
  [100001271,   Date.parse("17-May-2016"), 365],
  [100001274,   Date.parse("18-May-2016"), 365],
  [100001389,   Date.parse("8-Jun-2016"),  365],
  [100001561,   Date.parse("6-Jul-2016"),  365],
  [100001578,   Date.parse("3-Feb-2017"),  365],
  [100001665,   Date.parse("4-Feb-2017"),  365],
  [100002325,   Date.parse("5-Feb-2017"),  365],
  [100002693,   Date.parse("6-Feb-2017"),  365],
  [100000155,   Date.parse("3-Feb-2016"),  365],
  [100001380,   Date.parse("5-Jun-2014"),  365],
  [100001414,   Date.parse("1-Feb-2017"),  365],
  [100001656,   Date.parse("25-Mar-2017"), 365],
  [100001782,   Date.parse("6-Jan-2017"),  365],
  [100002403,   Date.parse("7-Jan-2017"),  365],
  [100002406,   Date.parse("6-Dec-2015"),  365],
  [100002473,   Date.parse("3-May-2015"),  365],
  [100002652,   Date.parse("12-Nov-2014"), 365],
  [100002721,   Date.parse("6-Apr-2017"),  365]
]

data.each {|d|
  AmDevice.new(*d).save!
}
