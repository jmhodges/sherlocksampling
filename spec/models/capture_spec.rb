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
  
  it "should not be complete when new or created" do
    @capture.should be_incomplete
    @capture.should_not be_completed
    @capture.should_not be_complete
    @capture.save
    @capture.should be_incomplete
    @capture.should_not be_completed
    @capture.should_not be_complete
    @capture.destroy # Clean up
  end
  
  it "should claim to be completed when told to be completed" do
    @capture.completed!
    @capture.should be_completed
  end
  
  it "should be able to find all of the bugs that are not duplicates" do
    bt = {:line_number => 2, :problem_code => "is foo"}

    @dup_bug = Bug.create(bt)
    @capture.save
    @capture.bugs = [
                    Bug.create(:line_number => 3, :problem_code => "f"),
                    Bug.create(:line_number => 4, :problem_code => "g"),
                    Bug.create(:line_number => 2, :problem_code => "like foo", :duplicate => @dup_bug)
                  ]
    
    @capture.should have(3).bugs
    @capture.should have(1).duplicate_bugs
    
    # Clean up, just in case
    @capture.bugs.map &:destroy
    @capture.destroy
  end
  
  it "should try to have the Sampling calculate the estimate when the Capture is completed." do
    @sampling.should_receive(:estimate_bug_counts)
    @capture.completed!
  end

  it "should be have a way to mail its reviewer"
end
