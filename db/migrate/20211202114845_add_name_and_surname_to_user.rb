class AddNameAndSurnameToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.string :name
      t.string :surname
    end
  end
end
