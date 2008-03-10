class Capture < ActiveRecord::Base
  belongs_to :sampling
  has_many :bugs, :dependent => :destroy

  validates_presence_of :sampling, :on => :save, :message => "can't be blank"
  Initial = 0
  Draft = 1
  Complete = 2
  
  def original_bugs
    bugs.find(:all, :conditions => "original_id IS NULL")
  end
  
  def initial?
    status == Initial
  end
  
  def draft?
    status == Draft
  end
  # Aliased just in case the annoyance of draft? not being symmetrical
  # with completed? is too great
  alias :drafted? :draft?
  
  def drafted!
    self.status = Draft
  end
  
  def complete?
    completed
  end
  
  def completed?
    status == Complete
  end
  
  def complete!
    completed!
  end
  
  def completed!
    self.sampling.gather_bugs_from_captures!
    self.status = Complete
  end
  
  def incomplete?
    incompleted?
  end
  
  def incompleted?
    !completed?
  end
  
end
