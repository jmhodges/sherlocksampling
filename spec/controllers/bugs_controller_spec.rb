require File.dirname(__FILE__) + '/../spec_helper'

describe BugsController do
  
  before(:each) do
    @empty_bug = mock_model(Bug)
    @empty_bug.stub!(:save).and_return(true)
    
    @bug_params = {"problem_code"=>"foo != bar", "line_number"=>"20"}
    
    @bug = mock_model(Bug)
    @bug.stub!(:save).and_return(true)
    @bug_params.keys.each{|k| @bug.stub!(k.to_sym).and_return(@bug_params[k])}
    
    @capture = mock_model(Capture)
    @capture.stub!(:bugs).and_return([])
    
    
    @sampling = mock_model(Sampling)
    @sampling.stub!(:captures).and_return([@capture])
    @sampling.captures.stub!(:find_by_id).with("1").and_return(@capture)
    @sampling.stub!(:uuid).and_return("abc")
    Sampling.stub!(:find_by_uuid).with("abc").and_return(@sampling)
  end
  
  it "should have a working new, and create" do

    @capture.bugs.stub!(:build).and_return(@empty_bug)
    get :new, { :sampling_id => "abc", :capture_id => 1}
    response.should be_success
    
    @capture.bugs.stub!(:build).with(@bug_params).and_return(@bug)
    
    get :create, { :sampling_id => "abc", :capture_id => 1, :bug => @bug_params}
    response.should be_redirect # Will be success for xhr's
    
    assigns[:bug].line_number.should eql(@bug_params["line_number"])
    assigns[:bug].problem_code.should eql(@bug_params["problem_code"])
  end
  
  it "should have a working edit, and update"
  it "should have a working delete and destroy"
  
end
