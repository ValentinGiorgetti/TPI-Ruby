class RemoveUnusedUserFields < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, name: "index_users_on_reset_password_token"
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :reset_password_token, :string
  end
end