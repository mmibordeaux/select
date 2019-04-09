class FixScholarshipBonus < ActiveRecord::Migration[5.2]
  def change
    rename_column :settings, :scholarship_bonus, :evaluation_scholarship_bonus
  end
end
