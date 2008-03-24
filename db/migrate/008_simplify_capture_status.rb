class SimplifyCaptureStatus < ActiveRecord::Migration
  def self.up
    remove_column :captures, :status
    add_column :captures, :completed, :boolean, :default => false
  end

  def self.down
    remove_column :captures, :status
    add_column :captures, :completed, :integer, :default => 0
  end
end
