class Sampling < ActiveRecord::Base
  validates_presence_of :uuid, :on => :save, :message => "can't be blank"
  validates_length_of :captures, :is => 2, :on => :save, :message => "must be present"
  has_many :captures, :dependent => :destroy
  has_many :bugs
  
  Complete = true;
  Incomplete = false;
  
  def complete?
    completed? # Defined by the boolean column 'completed'
  end
  
  def complete!
    completed!
  end
  
  def completed!
    unless captures.blank? || captures.any?(&:incomplete?)
      self.completed = Complete
    end
  end
  
  def incomplete?
    not self.completed
  end
  
  def incompleted?
    incomplete?
  end
  
  def incompleted!
    self.completed = Incomplete
  end
  
  # Gathers the bugs from captures but ignores duplicates
  def gather_bugs_from_captures
    # FIXME this be reduced to one SQL statement, but that is early optimization
    self.bugs = captures.map(&:original_bugs).flatten
  end
  
  def gather_bugs_from_captures!
    gather_bugs_from_captures
    save
  end
end
