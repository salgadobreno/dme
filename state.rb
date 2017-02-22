class State
  attr_reader :name

  def initialize(name, state_options)
    @name = name

    # register callbacks
    @validation_callbacks = state_options[:validation]
    @execution_callbacks = state_options[:execution]
  end

  def execute(payload)
    unless @execution_callbacks.nil? || @validation_callbacks.empty?
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
