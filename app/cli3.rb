#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'gli'
require 'tty-prompt'
require 'state'
require 'state_machine'
require 'device'

include GLI::App

program_desc 'Dashboard CLI APP'

pre do |global_options,command,options,args|
  # load 'db' into memory
  true
end

post do |global_options,command,options,args|
  # store 'db' state
  true
end

# simple db
# command actions
# refactor

@prompt = TTY::Prompt.new

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

desc "adds device"
command :add do |c|
  c.action do |global_options,options,args|
    # TODO: PARAM device_id?
    # request device_id
    # create device
    # define state machine
    #   -> NOTE: will be using fixed state machine for now
    bipa_prompt = 'Bipe a maquina:'

    payload = {}
    state_inicio = State.new :inicio, {
      :execution => [op_input_cliente, op_input_serial_number, op_input_inspecao, op_get_operator_input],
      :validation => nil
    }

    state_fim = State.new :fim, {
      :execution => nil,
      :validation => nil
    }

    state_machine = StateMachine.new [state_inicio, state_fim], @payload

    device_id = @prompt.ask bipa_prompt
    device = Device.new device_id, state_machine

    p device
  end
end

desc "forwards device"
command :fw do |c|
  c.action do
    # forwards device
  end
end

desc "list devices and their states"
command :ls do |c|
  c.action do
    # pretty print the list
  end
end

desc "shows device, state and events"
command :show do |c|
  c.action do |global_options,options,args|
    # PARAM: device
    # pretty print device and event history
  end
end

desc "remove device"
command :rm do |c|
  c.action do |global_options,options,args|
    # PARAM: device
    # rm device
  end
end

exit run(ARGV)
