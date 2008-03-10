class Sampling < ActiveRecord::Base
  has_many :captures, :dependent => :destroy
  
  validates_presence_of :uuid, :on => :save, :message => "can't be blank"
  validates_length_of :captures, :is => 2, :on => :save, :message => "must be present"
  
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
  
  def estimate_bug_counts
    # Simple mark and recapture algorithm
    num_bugs_found = 0 # Total number of bugs found by the reviewers
    num_duplicates = 0 # Number of duplicates
    numerator = 1 # The number of bugs found by each reviewer multiplied together
    
    captures.each do |c| 
      count = c.bugs.count
      num_duplicates += c.duplicate_bugs.count
      numerator *= count
      num_bugs_found += count - num_bugs_found
    end
    
    if numerator != 0 && num_duplicates != 0
      self.total_bug_estimate = numerator.to_f / num_duplicates.to_f
      self.missing_bug_estimate = total_bug_estimate - num_bugs_found
    else
      # One reviewer found zero bugs, so we can't make any estimates.
      # Or there were no duplicate bugs found.
      self.total_bug_estimate = nil
      self.missing_bug_estimate = nil
    end
    
    return [total_bug_estimate, missing_bug_estimate]
  end
  
  def estimate_bug_counts!
    estimate_bug_counts
    save
  end
  
end
