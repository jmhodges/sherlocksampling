class Capture < ActiveRecord::Base
  belongs_to :sampling
  
  Initial = 0
  Draft = 1
  Completed = 2
  
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
  
  def completed?
    status == Completed
  end
  
  def completed!
    self.status = Completed
  end
  
end
