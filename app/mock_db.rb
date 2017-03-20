require 'forwardable'

class MockDB
  extend Forwardable

  def initialize
    @devices = []
  end

  attr_reader :devices
  def_delegators :@devices, :<<

  def store store_location
    p Marshal.dump @devices
    Marshal.dump @devices, File.open(store_location, "w+")
    if File.exists? store_location
      true
    else
      false
    end
  end

  def self.restore store_location
    p File.read(store_location)
    p File.read(store_location)
    p File.read(store_location)

    Marshal.load(File.read(store_location))
  end

end
