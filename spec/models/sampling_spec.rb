require File.dirname(__FILE__) + '/../spec_helper'

describe Sampling do
  before(:each) do
    @sampling = Sampling.new
  end

  it "should be valid" do
    @sampling.should be_valid
  end
end
