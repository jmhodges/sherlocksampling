class AddCompletedToCapture < ActiveRecord::Migration
  def self.up
    add_column :captures, :status, :integer, :default => 0
  end

  def self.down
    remove_column :captures, :status
  end
end
