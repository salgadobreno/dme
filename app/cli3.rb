#!/usr/bin/env ruby
PROJ_PATH = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(PROJ_PATH << '/../')

require 'dashboard_init'
require 'gli'
require 'tty-prompt'
require 'tty-table'

#NOTE: Wrapping Cli3 in a module to work around GLI bug, see:
# "`binding.pry` does not work after including GLI": https://github.com/davetron5000/gli/issues/196
module Cli3
  include GLI::App
  extend self

  program_desc 'Dashboard CLI APP'

  def find_device device_id
    am_device = AmDevice.find_by serial_number: device_id.to_i
    device = am_device.device_sos.last
    exit_now! "Could not find device #{device_id}" if device.nil?

    device
  end

  def run_ls
    commands[:ls].execute nil, nil, nil
  end

  class OpInputClient < State::Operation
    def call(payload)
      table_client_prompt = "Select CRIENTE"
      table_client = TTY::Table.new header: ['id', 'nome'], rows: [['1', 'Avixy'], ['2', 'Cielo'], ['3', 'Rede']]
      payload[:answer_cliente] = TTY::Prompt.new.select table_client_prompt + "\n" + table_client.render(:ascii), ['Avixy','Cielo','Rede']
    end
  end

  class OpInputSerialNumber < State::Operation
    def call(payload)
      table_client_prompt = "Select CRIENTE"
      table_client = TTY::Table.new header: ['id', 'nome'], rows: [['1', 'Avixy'], ['2', 'Cielo'], ['3', 'Rede']]
      payload[:answer_cliente] = TTY::Prompt.new.select table_client_prompt + "\n" + table_client.render(:ascii), ['Avixy','Cielo','Rede']
    end
  end

  class OpInputInspection < State::Validation
    def call(payload)
      inspecao_visual_prompt = 'Realize inspecao visual(selecione com as setas e use espaço para selecionar)'
      inspecao_visual_opts = ['sem barata', 'teclado integro', 'sem coliformes']
      payload[:answer_inspecao_visual] = TTY::Prompt.new.multi_select inspecao_visual_prompt, inspecao_visual_opts
    end
  end

  class OpGetOperadorOk < State::Validation
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
      device_id = TTY::Prompt.new.ask bipa_prompt
      p "Setting sold_at to Today: #{Date.today}"
      p "Setting warranty_days as Default: 365"

      # define state machine
      state_inicio = State.new :inicio, {
        :operations => [OpInputClient.new, OpInputSerialNumber.new, OpInputInspection.new, OpGetOperadorOk.new],
        :validations => nil
      }

      state_fim = State.new :fim, {
        :operations => nil,
        :validations => nil
      }

      state_machine = StateMachine.new [state_inicio, state_fim]

      # creates device
      am_device = AmDevice.find_by(serial_number: device_id.to_i)
      device = DeviceSo.new am_device, state_machine
      device.save!

      #@buffer.add device
      #TODO: re-add buffer?
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
      device.save!

      run_ls
    end
  end

  desc "list devices and their states"
  command :ls do |c|
    c.action do
      # print the list in table format
      devices = DeviceSo.all
      d_rows = devices.map {|d| [d.serial_number, d.sold_at, d.warranty_days, d.current_state.name]}
      header = ['Serial number', 'Sold at', 'Warranty', 'Current State']
      table_devices = TTY::Table.new header: header, rows: d_rows
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
      rows = device.device_histories.map { |e| [e.created_at, e.description] }
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
      device.destroy
      run_ls
    end
  end

  exit run(ARGV)
end
