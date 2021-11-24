class Professional < ApplicationRecord
    has_many :appointments
    validates :name, presence: true, uniqueness: true, format: { with: /^[a-z A-Z]+$/, multiline: true }
end
