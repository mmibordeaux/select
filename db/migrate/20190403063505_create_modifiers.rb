class CreateModifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :modifiers do |t|
      t.string :title
      t.string :description
      t.float :value
      t.string :kind

      t.timestamps
    end
  end
end
