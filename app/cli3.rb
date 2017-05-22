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

  def prompt_text_input prompt
    @prompter ||= TTY::Prompt.new
    @prompter.ask prompt
  end

  desc "adds device"
  command :add do |c|
    c.action do |global_options,options,args|
      # request device_id
      device_id = prompt_text_input 'Bipe a maquina:'

      # creates device
      am_device = AmDevice.find_by(serial_number: device_id.to_i)
      if DeviceSo.where(am_device: am_device).any?
        #já está no lab
        print "Device already in lab\n"
      else
        device = DeviceSo.new am_device, state_machine
        state_machine = DefaultStateMachine.new
        device.save!

        #@buffer.add device
        #TODO: what will happen with buffer?
        run_ls
      end
    end
  end

  # TODO: forward whole state?
  desc "forwards device"
  command :fw do |c|
    c.action do |global_options, options, args|
      # Prompt device
      device_id = prompt_text_input 'Bipe a maquina:'
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
      am_device = device.am_device #grab the AssetManagerDevice because we want the full history
      puts "Device: %s" % device.serial_number
      puts "State: %s" % device.current_state.name
      puts "LOG:"
      rows = am_device.device_logs.map { |e| [e.created_at, e.description] }
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
