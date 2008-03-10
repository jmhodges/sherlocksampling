require File.dirname(__FILE__) + '/../spec_helper'

describe Sampling do
  before(:each) do
    @sampling = Sampling.new(:uuid => UUID.random_create.to_s)
  end

  it "should be valid" do
    @sampling.should be_valid
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
  
  it "should be complete when told to be completed" do
    @sampling.completed!
    @sampling.should be_complete
  end
end
