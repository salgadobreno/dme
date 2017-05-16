#this will be the absolute path to lib based on the calling __FILE__
lib = File.expand_path('../app', __FILE__)
#this will include the path in $LOAD_PATH unless it is already included
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

ENV["MONGODB_CFG_PATH"] ||= File.expand_path('../config', __FILE__) + "/mongoid.yml"

require "rake/testtask"
require "mongoid"
require "database_cleaner"
require "date"
require "./dashboard_init"
require "app_log"

task default: [:test]

desc "Run all applicaiton tests"
Rake::TestTask.new do |t|
  t.libs.push '.'
  t.libs.push File.expand_path('../test', __FILE__)

  t.pattern = [
    "test/*_test.rb",
    "test/models/*_test.rb",
    "test/functional/*_test.rb"
  ]
end

namespace :db do
  def clean_database
    DatabaseCleaner.clean
    return true
  rescue => error
    error "Error while cleaning the database: #{error}"
    return false
  end

  task :db_config do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    # drop the previous database fixtures
    if not clean_database
      abort "rake aborted!"
    end
  end

  desc "create the project fixtures"
  task :seed => :db_config do
    load './db/seed.rb'
  end

  desc "clean the database"
  task :clean => :db_config do
    clean_database
  end
end
