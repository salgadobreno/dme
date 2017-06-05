#$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__), '../'))
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/../'
require 'dashboard_init'
require 'app/app_service'

SERVICE = AppService.new
#all serial numbers
serial_numbers = AmDevice.all.map(&:serial_number)

# add all asset manager devices
serial_numbers.each do |sn|
  print "Adding: #{sn} .."
  SERVICE.add sn
  print ". true\n"
end

# forward all amdevices
serial_numbers.each do |sn|
  r = {:has_next => true}
  while (r[:has_next]) do
    #advance device to the end or it is segregated
    print "Forwarding: #{sn} .."
    r = SERVICE.fw sn
    print ". true\n"
  end
  print "Done #{sn}\n" if !r[:has_next]
end
