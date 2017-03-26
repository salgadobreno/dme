#!/usr/bin/env ruby
PROJ_PATH = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(PROJ_PATH << '/../')

require 'dashboard_init'
require 'gli'
require 'tty-prompt'
require 'tty-table'

include GLI::App

program_desc 'Dashboard CLI APP'

# TODO:
# x simple db
# x command actions
# refactor, extract commands

DB_LOCATION = './.db'

def find_device device_id
  device = @buffer.devices.values.flatten.find {|d|
    d.serial_number == device_id
  }

  exit_now! "Could not find device #{device_id}" if device.nil?

  device
end

def run_ls
  commands[:ls].execute nil, nil, nil
end

pre do |global_options,command,options,args|
  # load 'db' into memory
  begin
    mock_db = MockDB.restore(DB_LOCATION)
    @buffer = Buffer.new mock_db.devices
  rescue Errno::ENOENT => e # No such file
    @buffer = Buffer.new
  end
  true
end

post do |global_options,command,options,args|
  # store 'db' state
  mock_db = MockDB.new @buffer.devices.values.flatten #TODO: refactor api
  mock_db.store DB_LOCATION
  true
end

class OpInputClient
  def call(payload)
    table_client_prompt = "Select CRIENTE"
    table_client = TTY::Table.new header: ['id', 'nome'], rows: [['1', 'Avixy'], ['2', 'Cielo'], ['3', 'Rede']]
    payload[:answer_cliente] = TTY::Prompt.new.select table_client_prompt + "\n" + table_client.render(:ascii), ['Avixy','Cielo','Rede']
  end
end

class OpInputSerialNumber
  def call(payload)
    table_client_prompt = "Select CRIENTE"
    table_client = TTY::Table.new header: ['id', 'nome'], rows: [['1', 'Avixy'], ['2', 'Cielo'], ['3', 'Rede']]
    payload[:answer_cliente] = TTY::Prompt.new.select table_client_prompt + "\n" + table_client.render(:ascii), ['Avixy','Cielo','Rede']
  end
end

class OpInputInspection
  def call(payload)
    inspecao_visual_prompt = 'Realize inspecao visual(selecione com as setas e use espaço para selecionar)'
    inspecao_visual_opts = ['sem barata', 'teclado integro', 'sem coliformes']
    payload[:answer_inspecao_visual] = TTY::Prompt.new.multi_select inspecao_visual_prompt, inspecao_visual_opts
  end
end

class OpGetOperadorOk
  def call(payload)
    puts "Cliente: #{payload[:answer_cliente]}"
    puts "Numero Serial: #{payload[:answer_serial_number]}"
    puts "Dados de inspeção:\n#{TTY::Table.new(payload[:answer_inspecao_visual].map {|x| [x]}).render(:ascii)}"
    payload[:confirmed] = TTY::Prompt.new.yes?("Confirma recebimento?")
  end
end

desc "adds device"
command :add do |c|
  c.action do |global_options,options,args|
    # request device_id
    #   -> NOTE: will be using fixed state machine for now
    bipa_prompt = 'Bipe a maquina:'
    device_id = @prompt.ask bipa_prompt

    # define state machine
    state_inicio = State.new :inicio, {
      #:execution => [],
      :execution => [OpInputClient.new, OpInputSerialNumber.new, OpInputInspection.new, OpGetOperadorOk.new],
      :validation => nil
    }

    state_fim = State.new :fim, {
      :execution => nil,
      :validation => nil
    }

    state_machine = StateMachine.new [state_inicio, state_fim]

    # creates device
    device = Device.new device_id, state_machine

    @buffer.add device
    run_ls
  end
end

# TODO: forward whole state?
desc "forwards device"
command :fw do |c|
  c.action do |global_options, options, args|
    # PARAM: device id
    device_id = args[0]
    help_now! "Usage: fw [device_id]" if device_id.nil?

    device = find_device device_id

    # forwards device
    device.forward

    run_ls
  end
end

desc "list devices and their states"
command :ls do |c|
  c.action do
    # print the list in table format
    rows = @buffer.devices.values.flatten.map { |d| [d.current_state.name, d.serial_number] }
    table_devices = TTY::Table.new header: ['State', 'Serial Number'], rows: rows
    puts table_devices.render :ascii
  end
end

desc "shows device, state and events"
command :show do |c|
  c.action do |global_options,options,args|
    # PARAM: device
    device_id = args[0]
    help_now! "Usage: show [device_id]" if device_id.nil?

    device = find_device device_id
    puts "Device: %s" % device.serial_number
    puts "State: %s" % device.current_state.name
    puts "LOG:"
    rows = device.events.map { |e| ['xx/xx/xx', e] }
    table_log = TTY::Table.new header: ['Data', 'Evento'], rows: rows
    puts table_log.render :ascii
  end
end

desc "remove device"
command :rm do |c|
  c.action do |global_options,options,args|
    # PARAM: device
    device_id = args[0]
    help_now! "Usage: rm [device_id]" if device_id.nil?

    # rm device
    device = find_device device_id
    @buffer.rm device
    run_ls
  end
end

exit run(ARGV)
