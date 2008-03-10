require File.dirname(__FILE__) + '/../spec_helper'

describe Sampling do
  before(:each) do
    @sampling = Sampling.create(:uuid => UUID.random_create.to_s)
    @sampling.captures = [Capture.create(:sampling => @sampling), Capture.create(:sampling => @sampling)]
  end

  after(:each) do
    @sampling.captures.map &:destroy
    @sampling.destroy
  end
  
  it "should be valid" do
    @sampling.save!
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
  
  it "should estimate the number of bugs in total and the number of bugs left to be found correctly" do
    @sampling.captures[0].bugs.create
    @sampling.captures[1].bugs.create
    @sampling.captures[1].bugs.create(:duplicate => @sampling.captures[0].bugs[0])
    
    @sampling.estimate_bug_counts
    
    @sampling.total_bug_estimate.should eql(2)
    @sampling.missing_bug_estimate.should eql(0)
  end
  
  it "should refuse to estimate the number of bugs properly if one reviewer found zero (0) bugs" do
    @sampling.captures[1].bugs.create
    @sampling.captures[1].bugs.create
    
    @sampling.estimate_bug_counts
    
    @sampling.total_bug_estimate.should be_nil
    @sampling.missing_bug_estimate.should be_nil
  end
  
  it "should refuse to estimate the number of bugs properly if there were no duplicates" do
    @sampling.captures[0].bugs.create
    @sampling.captures[1].bugs.create
    @sampling.captures[1].bugs.create
    
    @sampling.estimate_bug_counts
    
    @sampling.total_bug_estimate.should be_nil
    @sampling.missing_bug_estimate.should be_nil
  end
end
