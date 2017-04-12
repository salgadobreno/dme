require 'sourcify'

class ProcSerializer
  def initialize(a_block)
    throw ArgumentError.new("Parameter is neither Proc/Lambda or String: #{@block}") unless a_block.is_a?(String) || a_block.is_a?(Proc)
    @block = a_block
  end

  def to_source
    @block.to_source
  end

  def from_source
    throw ArgumentError.new("Parameter is not String: #{@block}") unless @block.is_a? String
    eval @block
  end

end
