class AddDateTimeToAppointments < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :date_time, :datetime
  end
end
