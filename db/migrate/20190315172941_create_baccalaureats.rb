class CreateBaccalaureats < ActiveRecord::Migration[5.2]
  def change
    create_table :baccalaureats do |t|
      t.string :title
      t.references :parent, foreign_key: { to_table: :baccalaureats }
      t.float :quota

      t.timestamps
    end
  end
end
