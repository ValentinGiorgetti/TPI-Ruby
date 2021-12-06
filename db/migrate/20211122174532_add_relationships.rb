class AddRelationships < ActiveRecord::Migration[6.1]
  def change
    add_reference :appointments, :professional, index: true, foreign_key: true
  end
end
