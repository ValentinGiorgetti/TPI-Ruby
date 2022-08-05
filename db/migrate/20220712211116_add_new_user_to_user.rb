class AddNewUserToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :new_user, :boolean, default: false 
  end
end
