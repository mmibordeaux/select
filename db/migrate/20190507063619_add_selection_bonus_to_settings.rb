class AddSelectionBonusToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :selection_scholarship_bonus, :float
  end
end
