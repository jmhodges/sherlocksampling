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
end
