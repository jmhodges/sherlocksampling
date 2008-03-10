class AddBugEstimateColumnsToSampling < ActiveRecord::Migration
  def self.up
    add_column :samplings, :total_bug_estimate, :integer
    add_column :samplings, :missing_bug_estimate, :integer
  end

  def self.down
    remove_column :samplings, :total_bug_estimate
    remove_column :samplings, :missing_bug_estimate
  end
end
