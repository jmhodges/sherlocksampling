require File.dirname(__FILE__) + '/../spec_helper'

describe CapturesController do

  before(:each) do
    @capture = mock_model(Capture)
    @capture.stub!(:completed?).and_return(false)
    @capture.stub!(:incomplete?).and_return(true)
    @other_capture = mock_model(Capture)
    @other_capture.stub!(:completed?).and_return(true)
    @other_capture.stub!(:completed?).and_return(false)

    @capture.stub!(:id).and_return(1)
    Capture.stub!(:find_by_id).with(1).and_return(@capture)

    @sampling = mock_model(Sampling, :uuid => 'abc')
    @sampling.stub!(:id).and_return(1)

    @sampling.stub!(:captures).and_return([@other_capture, @capture])
    @sampling.captures.stub!(:find_by_id).with(2).and_return(nil)
    @sampling.captures.stub!(:find_by_id).with(1).and_return(@capture)
    Sampling.stub!(:find_by_uuid).with('abc').and_return(@sampling)
  end
  
  it "should not respond with any method if the Capture is not in the given Sampling" do
    post :show, {:sampling_id => @sampling.uuid, :id => @capture.id}
    response.should be_success
    
    @capture.stub!(:completed!).and_return(true)
    post :update, {:sampling_id => @sampling.uuid, :id => @capture.id, :capture => {}}
    response.should be_redirect # FIXME a "good" redirect!
    
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
  
  it "should allow updates, but only to its completion status" do
    capture_params = {"completed" => Capture::Complete, :sampling_id => 2}
    
    @capture.should_receive(:completed!)
    @capture.should_not_receive(:update_attributes)
    @capture.should_not_receive(:update_attribute)
    
    post :update, {:sampling_id => @sampling.uuid, :id => @capture.id, :capture => capture_params}
  end
  
  it "should not allow updates if the Capture is completed" do
    @capture.stub!(:completed?).and_return(true)
    @capture.stub!(:incomplete?).and_return(false)
    capture_params = {"completed" => Capture::Incomplete}
    
    @capture.should_not_receive(:completed!)
    
    post :update, {:sampling_id => @sampling.uuid, :id => @capture.id, :capture => capture_params}
  end

  it "should not set the status to completed if update is called with the Incomplete status"

  # it "should mail the other Capture's reviewer when the Capture is completed"
end

describe CapturesController, "with views integrated" do
  integrate_views

  before(:each) do
    @capture = mock_model(Capture)
    @capture.stub!(:completed?).and_return(false)
    @capture.stub!(:incomplete?).and_return(true)
    @capture.stub!(:id).and_return(1)
    Capture.stub!(:find_by_id).with(1).and_return(@capture)

    @sampling = mock_model(Sampling, :uuid => 'abc')
    @sampling.stub!(:id).and_return(1)
    @sampling.stub!(:captures).and_return([mock_model(Capture),@capture])
    @sampling.stub!(:description).and_return("Foobar, lines 10-20.rb")
    @sampling.captures.stub!(:find_by_id).with(2).and_return(nil)
    @sampling.captures.stub!(:find_by_id).with(1).and_return(@capture)
    Sampling.stub!(:find_by_uuid).with('abc').and_return(@sampling)

    @capture.stub!(:sampling).and_return(@sampling)
    @capture.stub!(:bugs).and_return([])
  end

  it "should not show the completion button if it has been completed" do
    get :show, {:sampling_id => @sampling.uuid, :id => @capture.id }
    response.should have_tag('input#completion_button')

    @capture.stub!(:completed?).and_return(true)

    get :show, {:sampling_id => @sampling.uuid, :id => @capture.id }
    response.should_not have_tag('input#completion_button')
  end
end
