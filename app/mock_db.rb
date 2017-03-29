require 'forwardable'

class MockDB
  extend Forwardable

  def initialize(devices = [])
    @devices = devices
  end

  attr_accessor :devices
  def_delegators :@devices, :<<

  def store store_location
    file = Marshal.dump self, File.open(store_location, "w+")
    file.flush
    if File.exist? store_location
      true
    else
      false
    end
  end

  def self.restore store_location
    Marshal.load(File.read(store_location))
  end

end
