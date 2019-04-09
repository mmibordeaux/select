class AddEvaluationBonusToBaccalaureats < ActiveRecord::Migration[5.2]
  def change
    add_column :baccalaureats, :evaluation_bonus, :float
  end
end
