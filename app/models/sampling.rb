class Sampling < ActiveRecord::Base
  validates_presence_of :uuid, :on => :save, :message => "can't be blank"
  
  has_many :captures
  
  Complete = true;
  Incomplete = false;
  
  def complete?
    completed? # Defined by the boolean column 'completed'
  end
  
  def complete!
    completed!
  end
  
  def completed!
    self.completed = Complete
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
  
end
