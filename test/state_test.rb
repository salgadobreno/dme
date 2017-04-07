require 'test_helper'

describe State do

  it "requires name"
  it "has Operation/Validation callbacks"
  describe "when callbacks are empty/nil" do
    it "should not explode"
  end
  describe "#execute" do
    it "should call operations"
  end
  describe "#validate" do
    it "should call validations"
  end
  describe "Saving and Restoring" do
    describe "when Operation/Validation is Proc/Lambda" do
      it "should store and restore the Block successfully"
    end
    describe "when Operation/Validation is a Class" do
      it "should serialize and deserialize the Class successfully"
    end
  end
end
