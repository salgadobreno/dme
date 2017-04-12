require 'mongoid'
require 'lib/proc_serializer'

class State
  include Mongoid::Document
  store_in collection: "lixos"

  attr_reader :validation_callbacks, :execution_callbacks
  alias_method :validations, :validation_callbacks
  alias_method :operations, :execution_callbacks

  field :name, type: String
  field :st_operation_callbacks, type: Array
  field :st_validation_callbacks, type: Array

  before_save do |doc|
    doc[:st_validation_callbacks] = @validation_callbacks.map { |e| ProcSerializer.new(e).to_source } unless @validation_callbacks.nil?
    doc[:st_operation_callbacks] = @operation_callbacks.map { |e| ProcSerializer.new(e).to_source } unless @operation_callbacks.nil?
    p "before_save"
  end

  after_find do |doc|
    doc[:st_validation_callbacks]
    doc[:st_operation_callbacks]
    p "after_find"
  end

  def initialize(name, state_options)
    raise ArgumentError.new "Name is required" if name == nil
    super(name: name)

    # register callbacks
    @validation_callbacks = state_options[:validation]
    @execution_callbacks = state_options[:execution]
    p "initialized State"
  end

  def execute(payload)
    unless @execution_callbacks.nil? || @execution_callbacks.empty?
      @execution_callbacks.each {|eb| eb.call(payload)}
    end
  end

  def validate(payload)
    r = nil

    if @validation_callbacks.nil? || @validation_callbacks.empty?
      r = true
    else
      # chama all? em array de Boolean, se algum falhar, retorna falso
      r = @validation_callbacks.map { |validation|
        validation.call(payload)
      }.all?
    end

    return r
  end

  def to_s
    "State{name: #{@name}}"
  end

end
