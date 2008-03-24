class Capture < ActiveRecord::Base
  belongs_to :sampling
  has_many :bugs, :dependent => :destroy
  has_many :duplicate_bugs, :class_name => "Bug", :conditions => "original_id IS NOT NULL"
  
  Incomplete = false
  Complete = true
  
  def complete?
    completed?
  end
  
  def complete!
    completed!
  end
  
  def completed!
    self.sampling.estimate_bug_counts
    self.completed = Complete
  end
  
  def incomplete?
    incompleted?
  end
  
  def incompleted?
    !completed?
  end
  
end
