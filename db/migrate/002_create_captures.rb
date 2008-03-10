class CreateCaptures < ActiveRecord::Migration
  def self.up
    create_table :captures do |t|
      t.string :uuid
      t.references :sampling
      t.timestamps
    end
    
    add_index(:captures, :uuid)
  end

  def self.down
    drop_table :captures
    remove_index(:captures, :uuid)
  end
end
