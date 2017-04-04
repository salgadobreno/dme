# implementando o fluxo do programa com prompts

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'tty-prompt'
require 'tty-table'
require "irb"
require "state_machine"
require "state"
require "buffer"
require "device"

@prompt = TTY::Prompt.new
@payload = {}
@payload[:answers] = {}

op_input_cliente = lambda {|payload|
  table_client_prompt = "Select CRIENTE"
  table_client = TTY::Table.new header: ['id', 'nome'], rows: [['1', 'Avixy'], ['2', 'Cielo'], ['3', 'Rede']]
  payload[:answers][:cliente] = @prompt.select table_client_prompt + "\n" + table_client.render(:ascii), ['Avixy','Cielo','Rede']
}

op_input_serial_number = lambda {|payload|
  bipa_prompt = 'Bipe a maquina:'
  payload[:answers][:serial_number] = @prompt.ask bipa_prompt
}

op_input_inspecao = lambda {|payload|
  inspecao_visual_prompt = 'Realize inspecao visual(selecione com as setas e use espaço para selecionar)'
  inspecao_visual_opts = ['sem barata', 'teclado integro', 'sem coliformes']
  payload[:answers][:inspecao_visual] = @prompt.multi_select inspecao_visual_prompt, inspecao_visual_opts
}

op_get_operator_input = lambda {|payload|
  puts "Cliente: #{@payload[:answers][:cliente]}"
  puts "Numero Serial: #{@payload[:answers][:serial_number]}"
  puts "Dados de inspeção:\n#{TTY::Table.new(@payload[:answers][:inspecao_visual].map {|x| [x]}).render(:ascii)}"
  @payload[:confirmed] = @prompt.yes?("Confirma recebimento?")
}

state_inicio = State.new :inicio, {
  :execution => [op_input_cliente, op_input_serial_number, op_input_inspecao, op_get_operator_input],
  :validation => nil
}

state_fim = State.new :fim, {
  :execution => nil,
  :validation => nil
}

state_machine = StateMachine.new [state_inicio, state_fim], @payload

device = Device.new 999, state_machine

while device.forward
  p ""
end

p device.events.inspect

#while state_machine.has_next?
  #state_machine.forward
#end

