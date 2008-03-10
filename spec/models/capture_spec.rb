require File.dirname(__FILE__) + '/../spec_helper'

describe Capture do
  before(:each) do
    @capture = Capture.new(:uuid => UUID.random_create.to_s)
  end

  it "should be valid" do
    @capture.should be_valid
  end
  
  it "should require a UUID" do
    Capture.new.should_not be_valid
  end
end
