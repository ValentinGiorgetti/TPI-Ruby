class Professional < ApplicationRecord
    has_many :appointments, dependent: :delete_all
    validates :name, presence: true, uniqueness: true, format: { with: /^[a-z A-Z0-9]+$/, multiline: true }

    def has_pending_appointments?
        not appointments.not_finished.empty?
    end
end
