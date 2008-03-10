class AddDescriptionToSampling < ActiveRecord::Migration
  def self.up
    add_column :samplings, :description, :text
  end

  def self.down
    remove_column :samplings, :description
  end
end
