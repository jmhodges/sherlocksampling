require File.dirname(__FILE__) + '/../spec_helper'

describe SamplingsController do
  controller_name :samplings
  
  it "should show a Sampling by its UUID" do
    sampling = mock_model(Sampling)

    Sampling.stub!(:find_by_uuid).with("uuid123").and_return(sampling)
    
    get :show, :id => "uuid123"
    assigns[:sampling].should equal(sampling)
  end
  
  it "should respond to new" do
    Sampling.stub!(:new).and_return(@sampling)
    get :new
    assigns[:sampling].should equal(@sampling)
  end
  
  it "should not respond to edit or update" do
    @controller.should_not respond_to(:edit)
    @controller.should_not respond_to(:update)
  end
    
  it "should create two Captures attached to the Sampling in create" do
    post :create, {:sampling => {:description => "Foo bar foobar."}}
    assigns[:sampling].should be_valid
  end
  
  it "should require a description in create" do
    post :create, {:sampling => {}}
    response.headers['Status'].should eql("400 Bad Request")
    
    post :create, {:sampling => {:description => "Flib gib"}}
    response.headers['Status'].should_not eql("400 Bad Request")
  end
  
  it "should redirect to the show after create is run successfully" do
    post :create, {:sampling => {:description => "Baz"}}
    response.should redirect_to(:action => :show, :id => assigns[:sampling].uuid)
    
    post :create, {:sampling => {}}
    response.should_not be_redirect
  end
    
  # it "should send emails to the reviewers and the creator in create"
end

describe SamplingsController, "with views integrated" do
  controller_name :samplings
  integrate_views
  
  before(:each) do
    @sampling = mock_model(Sampling, :created_at => Time.now)
  end
  
  it "should respond to show properly" do
    Sampling.stub!(:find_by_uuid).with("uuid123").and_return(@sampling)
    
    get :show, :id => "uuid123"
    response.should be_success
  end
  
  it "should have a description textarea in new in HTML" do
    post :new
    response.should have_tag('form') do
      with_tag('textarea')
    end
  end
end
