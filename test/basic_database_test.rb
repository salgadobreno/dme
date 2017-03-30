require "irb"
require "minitest/autorun"
require "mocha/mini_test"
require "mongoid"
require "database_cleaner"

class TestModel
  include Mongoid::Document

   field :name
end

describe "Database configuration" do
  $db_conn = nil

  before do
    if $db_conn.nil?
      cfg_file = "#{File.expand_path(File.dirname(__FILE__))}/mongoid.yml"
      $db_conn = Mongoid.load! cfg_file, :development
    end

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end

  describe "testing a basic connection" do
    it "should have something in the conn object" do
      refute_nil $db_conn, "The database server is running?"
    end

    it "shoudl create a new model object and save it to the database" do
      model = TestModel.new
      model.name = "Fluflu"
      assert model.save!, true
    end
  end
end
