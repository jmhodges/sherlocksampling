class CreateSamplings < ActiveRecord::Migration
  def self.up
    create_table :samplings do |t|
      t.string :uuid
      t.timestamps
    end
    
    add_index(:samplings, :uuid)
  end

  def self.down
    drop_table :samplings
    remove_index(:samplings, :uuid)
  end
end
