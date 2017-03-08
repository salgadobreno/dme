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

table_cliente_prompt = "Select CRIENTE"
table_cliente = TTY::Table.new header: ['id', 'nome'], rows: [['1', 'Avixy'], ['2', 'Cielo'], ['3', 'Rede']]

#table_transportador_question = "Select TRNASPORTADORA"
#table_transp = TTY::Table.new header: ['id', 'nome'], rows: [['1', 'Rapidao'], ['2', 'Cometa']]

bipa_prompt = 'Bipe a maquina:'

inspecao_visual_prompt = 'Realize inspecao visual(selecione com as setas e use espaço para selecionar)'
inspecao_visual_opts = ['sem barata', 'teclado integro', 'sem coliformes']

h_respostas = {}

h_respostas[:cliente] = @prompt.select table_cliente_prompt + "\n" + table_cliente.render(:ascii), ['Avixy','Cielo','Rede']
h_respostas[:serial_number] = @prompt.ask bipa_prompt
h_respostas[:inspecao_visual] = @prompt.multi_select inspecao_visual_prompt, inspecao_visual_opts

puts "Cliente: #{h_respostas[:cliente]}"
puts "Numero Serial: #{h_respostas[:serial_number]}"
puts "Dados de inspeção:\n#{TTY::Table.new(h_respostas[:inspecao_visual].map {|x| [x]}).render(:ascii)}"
@prompt.yes? "Confirma recebimento?"

#p h_respostas[:inspecao_visual].map {|x| [x]}.inspect

#p h_respostas.inspect
