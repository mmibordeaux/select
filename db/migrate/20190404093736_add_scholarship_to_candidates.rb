class AddScholarshipToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :scholarship, :boolean, default: false
  end
end
