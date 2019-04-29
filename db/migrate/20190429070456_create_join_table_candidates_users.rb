class CreateJoinTableCandidatesUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :candidates, :users do |t|
      t.references :candidate, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
