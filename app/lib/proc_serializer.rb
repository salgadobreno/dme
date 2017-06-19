require 'sourcify'
require 'app/core/models/state'

# Allows for storing Procs/Lambdas in database so Operations/Validations can be defined
# and stored more easily. This method *WON't be the preffered way* since the backing library
# has bugs and is unmaintained, but can be used to speed up development/prototyping. If an
# Operation/Validation is production-ready, it should be made into a class instead.
class ProcSerializer

  def initialize(a_block)
    unless a_block.is_a?(String) || a_block.is_a?(Proc) || a_block.is_a?(State::Operation) || a_block.is_a?(State::Validation)
      throw ArgumentError.new("Parameter is not: Proc, Lambda, String, State::Validation or State::Operation : #{@block}")
    end
    @block = a_block
  end

  def to_source
    if @block.respond_to? :to_source
      @block.to_source
    else
      Marshal.dump @block
    end
  end

  def from_source
    throw ArgumentError.new("Parameter is not String: #{@block}") unless @block.is_a? String
    begin
      Marshal.load @block
    rescue TypeError => e
      eval @block
    end
  end

  alias_method :serialize, :to_source
  alias_method :restore, :from_source
end
