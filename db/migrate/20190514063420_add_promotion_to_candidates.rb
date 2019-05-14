class AddPromotionToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :promotion_selected, :boolean, default: false
    add_column :candidates, :promotion_decile, :integer
    add_column :candidates, :promotion_position, :integer
  end
end
