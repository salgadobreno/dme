# implementando o fluxo do programa com prompts

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'tty-prompt'
require 'tty-table'
require "irb"
require "state_machine"
require "state"
require "item"
require "buffer"

@prompt = TTY::Prompt.new
@payload = {}
@payload[:respostas] = {}

op_input_cliente = lambda {|payload|
  table_cliente_prompt = "Select CRIENTE"
  table_cliente = TTY::Table.new header: ['id', 'nome'], rows: [['1', 'Avixy'], ['2', 'Cielo'], ['3', 'Rede']]
  payload[:respostas][:cliente] = @prompt.select table_cliente_prompt + "\n" + table_cliente.render(:ascii), ['Avixy','Cielo','Rede']
}

op_input_serial_number = lambda {|payload|
  bipa_prompt = 'Bipe a maquina:'
  payload[:respostas][:serial_number] = @prompt.ask bipa_prompt
}

op_input_inspecao = lambda {|payload|
  inspecao_visual_prompt = 'Realize inspecao visual(selecione com as setas e use espaço para selecionar)'
  inspecao_visual_opts = ['sem barata', 'teclado integro', 'sem coliformes']
  payload[:respostas][:inspecao_visual] = @prompt.multi_select inspecao_visual_prompt, inspecao_visual_opts
}

def execute(operation)
  operation.call @payload
end

execute op_input_cliente
execute op_input_serial_number
execute op_input_inspecao


puts "Cliente: #{@payload[:respostas][:cliente]}"
puts "Numero Serial: #{@payload[:respostas][:serial_number]}"
puts "Dados de inspeção:\n#{TTY::Table.new(@payload[:respostas][:inspecao_visual].map {|x| [x]}).render(:ascii)}"
@prompt.yes? "Confirma recebimento?"
