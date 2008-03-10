class Bug < ActiveRecord::Base
  belongs_to :capture
  belongs_to :sampling
  
  # By setting the foreign key on the original bug, we can assume avoid 
  # some extra seeks when trying to show only the "original" bug while 
  # still trying show a link to the duplicate with a smartly created 
  # duplicate? method.
  # Note that a duplicate bug is one that two (or more) reviewers found 
  # and added.
  belongs_to :duplicate, :class_name => "Bug", :foreign_key => "original_id"
  has_one :original, :class_name => "Bug", :foreign_key => "original_id"
  
  validates_uniqueness_of :original_id, :on => :save, 
    :message => "must be unique", 
    :allow_nil => true
  
  def duplicate?
    # Is a duplicate if it has an original
    original
  end
  
  def original?
    !duplicate?
  end
end
