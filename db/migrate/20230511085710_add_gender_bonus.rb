class AddGenderBonus < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :selection_gender_bonus, :integer
  end
end
