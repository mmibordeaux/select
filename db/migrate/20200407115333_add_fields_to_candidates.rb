class AddFieldsToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :gender, :string
    add_column :candidates, :baccalaureat_mention, :string
  end
end
