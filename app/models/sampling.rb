class Sampling < ActiveRecord::Base
  validates_presence_of :uuid, :on => :save, :message => "can't be blank"
end
