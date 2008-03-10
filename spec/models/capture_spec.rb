require File.dirname(__FILE__) + '/../spec_helper'

describe Capture do
  before(:each) do
    @capture = Capture.new()
  end

  it "should be valid" do
    @capture.should be_valid
  end
  
  it "should have the inital status when new or created" do
    @capture.should be_initial
    @capture.save
    @capture.should be_initial
    @capture.destroy # Clean up
  end
  
  it "should claim to be completed when told to be completed" do
    @capture.completed!
    @capture.should be_completed
  end
  
  it "should claim to be a draft when told be a draft" do
    @capture.drafted!
    @capture.should be_draft
    @capture.should be_drafted
  end
end
