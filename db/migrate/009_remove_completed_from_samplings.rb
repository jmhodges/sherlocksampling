class RemoveCompletedFromSamplings < ActiveRecord::Migration
  def self.up
    remove_column :samplings, :completed
  end

  def self.down
    add_column :samplings, :completed, :boolean,   :default => false
  end
end
