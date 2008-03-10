class CreateBugs < ActiveRecord::Migration
  def self.up
    create_table :bugs do |t|
      t.references  :capture
      t.integer     :line_number
      t.text        :problem_code
      t.references  :original, :class => Bug
      t.timestamps
    end
  end

  def self.down
    drop_table :bugs
  end
end
