class CreateCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :candidates do |t|
      t.string :number
      t.string :first_name
      t.string :last_name
      t.references :baccalaureat, foreign_key: true

      t.timestamps
    end
  end
end
