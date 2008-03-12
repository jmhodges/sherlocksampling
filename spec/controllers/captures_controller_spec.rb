require File.dirname(__FILE__) + '/../spec_helper'

describe CapturesController do

  before(:each) do
    @capture = mock_model(Capture)
    @capture.stub!(:status).and_return(Capture::Initial)
    @capture.stub!(:id).and_return(1)
    Capture.stub!(:find_by_id).with(1).and_return(@capture)
    
    @sampling = mock_model(Sampling, :uuid => 'abc')
    @sampling.stub!(:id).and_return(1)
    @sampling.stub!(:captures).and_return([mock_model(Capture),@capture])
    @sampling.captures.stub!(:find_by_id).with(2).and_return(nil)
    @sampling.captures.stub!(:find_by_id).with(1).and_return(@capture)
    Sampling.stub!(:find_by_uuid).with('abc').and_return(@sampling)
  end
  
  it "should not respond with any method if the Capture is not in the given Sampling" do
    post :show, {:sampling_id => @sampling.uuid, :id => @capture.id}
    response.should be_success
    
    @capture.stub!(:update_attributes).and_return(true)
    post :update, {:sampling_id => @sampling.uuid, :id => @capture.id, :capture => {}}
    response.should be_success
    
    post :show, {:id => @capture.id}
    response.should_not be_success
    response.should_not be_redirect
    
    post :update, {:id => @capture.id, :capture => {}}
    response.should_not be_success
    response.should_not be_redirect
  end
  
  it "should not respond to new, create, destroy or delete" do # At least, not until we add more math.
    @controller.should_not respond_to(:create)
    @controller.should_not respond_to(:new)
    @controller.should_not respond_to(:destroy)
    @controller.should_not respond_to(:delete)
    @controller.should_not respond_to(:edit)
  end
  
  it "should respond to show and update" do
    @controller.should respond_to(:show)
    @controller.should respond_to(:update)
  end
  
  it "should allow updates, but only to its status" do
    capture_params = {"status" => Capture::Complete, :sampling_id => 2}
    
    @capture.should_not_receive(:update_attributes).with(capture_params).and_return(true)
    @capture.should_receive(:update_attributes).with({"status" => Capture::Complete}).and_return(true)
    
    post :update, {:sampling_id => @sampling.uuid, :id => @capture.id, :capture => capture_params}
  end
  
  it "should not allow updates if the Capture is completed" do
    @capture.stub!(:status).and_return(Capture::Complete)
    capture_params = {"status" => Capture::Initial}
    
    @capture.should_not_receive(:update_attributes).with(capture_params)
    
    post :update, {:sampling_id => @sampling.uuid, :id => @capture.id, :capture => capture_params}
  end
  # it "should mail the other Capture's reviewer when the Capture is completed"
end
