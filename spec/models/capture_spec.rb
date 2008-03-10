require File.dirname(__FILE__) + '/../spec_helper'

describe Capture do
  before(:each) do
    @capture = Capture.new
    @sampling = Sampling.create(:captures => [@capture, Capture.new])
    @capture.sampling = @sampling
  end
  
  after(:each) do
    @sampling.destroy
  end

  it "should be valid" do
    @capture.save!
    @capture.should be_valid
  end
  
  it "should have the inital status when new or created" do
    @capture.should be_initial
    @capture.save
    @capture.should be_initial
    @capture.should be_incomplete
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
    @capture.should be_incomplete
  end
  
  it "should be able to find all of the bugs that are not duplicates" do
    @dup_bug = Bug.create
    @capture.save
    @capture.bugs = [Bug.create, Bug.create, Bug.create(:duplicate => @dup_bug)]
    
    @capture.should have(3).bugs
    @capture.should have(2).original_bugs
    
    # Clean up, just in case
    @capture.bugs.map &:destroy
    @capture.destroy
  end
  
  it "should sync all of its original bugs to its Sampling when it is completed" do
    @capture.save
    @capture.bugs = [Bug.create]
    bugs = [Bug.create, Bug.create(:duplicate => @capture.bugs[0])]
    
    other_capture = Capture.create(:bugs => bugs, :sampling => @capture.sampling )
    @sampling.captures = [@capture, other_capture]
    
    @capture.completed!
    
    @capture.sampling.should have(2).original_bugs
    @capture.sampling.should have(3).bugs
    # Clean up
    other_capture.destroy
    @capture.destroy
  end 
end
