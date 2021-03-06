require File.dirname(__FILE__) + '/../spec_helper'

describe Bug do
  before(:each) do
    @bug = Bug.new(:line_number => 2, :problem_code => "FOooo")
  end

  it "should be valid" do
    @bug.should be_valid
  end
  
  it "should be able to be called a duplicate" do
    @bug.save
    @other_bug = Bug.create(:duplicate => @bug,
                            :line_number => @bug.line_number,
                            :problem_code => @bug.problem_code
    )
    @bug.should be_duplicate
    @bug.should_not be_original
  end
    
  it "should be able to be called an original" do
    @bug.duplicate = Bug.new
    @bug.should be_original
    @bug.should_not be_duplicate
  end
end
