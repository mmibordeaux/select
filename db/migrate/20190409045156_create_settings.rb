class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.float :scholarship_bonus
      t.integer :interview_number_of_candidates

      t.timestamps
    end
  end
end
