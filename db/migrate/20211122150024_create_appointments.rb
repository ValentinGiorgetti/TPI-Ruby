class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.string :name
      t.string :surname
      t.integer :phone
      t.string :notes

      t.timestamps
    end
  end
end
