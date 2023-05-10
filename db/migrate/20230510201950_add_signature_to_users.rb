class AddSignatureToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :signature, :text
  end
end
