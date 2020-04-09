class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_evaluation_baccalaureats, :string
    add_column :users, :first_evaluation_quota, :integer
    add_column :users, :second_evaluation_baccalaureats, :string
    add_column :users, :second_evaluation_quota, :integer
  end
end
