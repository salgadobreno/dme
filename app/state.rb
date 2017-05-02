require 'mongoid'
require 'lib/proc_serializer'

class State
  class OperationArray < Array
    class << self
      # Get the object as it was stored in the database, and instantiate
      # this custom class from it.
      def demongoize(object)
        object.map { |e| ProcSerializer.new(e).from_source }
      end

      # Converts the object that was supplied to a criteria and converts it
      # into a database friendly form.
      def evolve(object)
        case object
        when OperationArray then object.mongoize
        else object
        end
      end

      # Takes any possible object and converts it to how it would be
      # stored in the database.
      def mongoise(object)
        object.mongoise
      end
    end

    def mongoize
      self.map { |e| ProcSerializer.new(e).to_source }
    end
  end

  class ValidationArray < OperationArray
  end

  include Mongoid::Document

  embedded_in :state_machine
  field :name, type: String
  field :operations, type: OperationArray
  field :validations, type: ValidationArray

  def initialize(name, state_options)
    raise ArgumentError.new "Name is required" if name == nil
    # register callbacks
    validation_callbacks = ValidationArray.new state_options[:validations] || []
    operation_callbacks = OperationArray.new state_options[:operations] || []

    super(name: name, validations: validation_callbacks, operations: operation_callbacks)
  end

  def execute(payload)
    unless operations.nil? || operations.empty?
      operations.each {|eb| eb.call(payload)}
    end
  end

  def validate(payload)
    r = nil

    if validations.nil? || validations.empty?
      r = true
    else
      # chama all? em array de Boolean, se algum falhar, retorna falso
      r = validations.map { |validation|
        validation.call(payload)
      }.all?
    end

    return r
  end

  def inspect
    "#{super} | @operations: #{operations.inspect}, @validations: #{validations.inspect}"
  end

end
