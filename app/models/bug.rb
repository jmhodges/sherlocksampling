class Bug < ActiveRecord::Base
  belongs_to :capture
  belongs_to :sampling
  
  # By setting the foreign key on the original bug, we can assume avoid 
  # some extra seeks when trying to show only the "original" bug while 
  # still trying show a link to the duplicate with a smartly created 
  # duplicate? method.
  # Note that a duplicate bug is one that two (or more) reviewers found 
  # and added.
  belongs_to :duplicate, :class_name => "Bug", :foreign_key => "duplicate_id"
  has_one :duplicate_of, :class_name => "Bug", :foreign_key => "duplicate_id"
  
  
  def duplicate?
    # If the bug is a duplicate, it's duplicate_id will be nil. If it 
    # is the "original", its duplicate_id will point to another bug.
    !original? 
  end
  
  def original?
    # This means it has a duplicate Bug, not that it has column called 
    # duplicate that is set to true.
    duplicate  
  end
end
