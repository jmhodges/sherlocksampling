class AddStatusToSamplings < ActiveRecord::Migration
  def self.up
    add_column :samplings, :completed, :boolean
  end

  def self.down
    remove_column :samplings, :completed
  end
end
