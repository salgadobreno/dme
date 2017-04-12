require 'mongoid'
require 'lib/proc_serializer'

class State
  include Mongoid::Document

  attr_reader :validation_callbacks, :operation_callbacks
  alias_method :validations, :validation_callbacks
  alias_method :operations, :operation_callbacks

  field :name, type: String
  field :st_operation_callbacks, type: Array
  field :st_validation_callbacks, type: Array

  before_save do |doc|
    doc[:st_validation_callbacks] = @validation_callbacks.map { |e| ProcSerializer.new(e).to_source } if !@validation_callbacks.nil? || !@validation_callbacks.empty?
    doc[:st_operation_callbacks] = @operation_callbacks.map { |e| ProcSerializer.new(e).to_source } if !@operation_callbacks.nil? || !@operation_callbacks.empty?
  end

  after_find do |doc|
    @operation_callbacks = doc[:st_operation_callbacks].map { |e| ProcSerializer.new(e).from_source } unless st_operation_callbacks.nil?
    @validation_callbacks = doc[:st_validation_callbacks].map { |e| ProcSerializer.new(e).from_source } unless st_validation_callbacks.nil?
    doc[:st_validation_callbacks]
    doc[:st_operation_callbacks]
  end

  def initialize(name, state_options)
    raise ArgumentError.new "Name is required" if name == nil
    super(name: name)

    # register callbacks
    @validation_callbacks = state_options[:validation]
    @operation_callbacks = state_options[:operation]
  end

  def execute(payload)
    unless @operation_callbacks.nil? || @operation_callbacks.empty?
      @operation_callbacks.each {|eb| eb.call(payload)}
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
