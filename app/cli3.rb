#!/usr/bin/env ruby
PROJ_PATH = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(PROJ_PATH << '/../')

#require 'dashboard_init'
require 'gli'
require 'tty-prompt'
require 'tty-table'
require 'app/services/app_service'

#NOTE: Wrapping Cli3 in a module to work around GLI bug, see:
# "`binding.pry` does not work after including GLI": https://github.com/davetron5000/gli/issues/196
module Cli3
  include GLI::App
  extend self
  SERVICE = AppService.new

  program_desc 'Dashboard CLI APP'

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
      r = SERVICE.add device_id
      p r[:message] if r[:message]

      run_ls
    end
  end

  # TODO: forward whole state?
  desc "forwards device"
  command :fw do |c|
    c.action do |global_options, options, args|
      # Prompt device
      device_id = prompt_text_input 'Bipe a maquina:'
      r = SERVICE.fw device_id

      if r[:success]
        run_ls
      else
        p "fail"
      end
    end
  end

  desc "list devices and their states"
  command :ls do |c|
    c.action do
      # print the list in table format
      r = SERVICE.list
      d_rows = r[:devices].map {|d| [d.serial_number, d.sold_at, d.warranty_days, d.current_state.name]}
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
      r = SERVICE.show device_id

      puts "Device: %s" % r[:device].serial_number
      puts "State: %s" % r[:device].current_state.name
      puts "LOG:"
      rows = r[:device_logs].map { |e| [e.created_at, e.description] }
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
      SERVICE.rm device_id

      run_ls
    end
  end

  exit run(ARGV)
end
