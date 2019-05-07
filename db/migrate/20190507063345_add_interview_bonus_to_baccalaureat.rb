class AddInterviewBonusToBaccalaureat < ActiveRecord::Migration[5.2]
  def change
    add_column :baccalaureats, :selection_bonus, :float
  end
end
