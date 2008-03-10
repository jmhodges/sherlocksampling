require File.dirname(__FILE__) + '/../spec_helper'

describe Sampling do
  before(:each) do
    @sampling = Sampling.new(:uuid => UUID.random_create.to_s)
    @sampling.captures = [Capture.new, Capture.new]
  end

  it "should be valid" do
    @sampling.should be_valid
  end
  
  it "should require exactly two Capture (This will change later)" do
    @sampling.captures = [Capture.new]
    @sampling.should_not be_valid
    @sampling.captures = [Capture.new, Capture.new, Capture.new]
    @sampling.should_not be_valid
  end
  
  it "should require a UUID" do
    Sampling.new.should_not be_valid
  end
  
  it "should be incomplete when new or created" do
    @sampling.should_not be_completed
    @sampling.should be_incomplete
    @sampling.save
    @sampling.should_not be_completed
    @sampling.should be_incomplete
    @sampling.destroy # Clean up
  end
  
  it "should be complete when told to be completed and its Captures are complete" do
    @sampling.captures = [Capture.new(:status => Capture::Complete), Capture.new(:status => Capture::Complete)]
    @sampling.completed!
    @sampling.should be_complete
  end
  
  it "should not be completable if it does not have any Captures" do
    @sampling.captures = []
    @sampling.completed!
    @sampling.should_not be_complete
  end
  
  it "should not be completable if any of its Captures are not complete" do
    @sampling.completed!.should_not be_true
    @sampling.should_not be_completed
  end
end
