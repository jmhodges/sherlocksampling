require File.dirname(__FILE__) + '/../spec_helper'

describe Capture do
  before(:each) do
    @capture = Capture.new
  end

  it "should be valid" do
    @capture.should be_valid
  end
end
