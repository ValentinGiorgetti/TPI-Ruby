class Appointment < ApplicationRecord
    belongs_to :professional
    validates :name, :surname, :phone, :date_time, :professional, presence: true
    validates :date_time, uniqueness: { scope: :professional_id }
    validates :name, :surname, format: { with: /^[a-z A-Z0-9]+$/, multiline: true }

    validate :validate_phone, :validate_date_time
    
    default_scope { order(date_time: 'asc') }

    scope :not_finished, -> { where("date_time > ?", Time.current) }

    ransack_alias :patient_name, :name
    ransack_alias :patient_surname, :surname

    def validate_phone
        if not phone.to_s.match(/^[\d]+$/)
            errors.add(:phone, "invalid")
        end
    end

    def finished?
        date_time < DateTime.now()
    end

    def validate_date_time
        if (finished? and (date_time_was != date_time))
            errors.add(:date_time, "is old")
        end
    end

    def date_time_string
        date_time.strftime("%d-%m-%Y %H:%M")
    end

    def self.valid_hours()
        hours = (9..21).collect { | hour | (hour >= 10) ? "#{hour}:00" : "0#{hour}:00" }
    end

    def date
        date_time.strftime("%d-%m-%Y")
    end

    def hour
        date_time.strftime("%H:%M")
    end

    def professional_name
        self.professional.name
    end

    def self.all_appointments_by_date(date, professional_id = "")
        appointments = Appointment.where(date_time: date.all_day)

        if not professional_id.empty?
            professional = Professional.find(professional_id)
            appointments = appointments.where(professional: professional)
        end
        
        appointments
    end

    def self.all_appointments_by_week(initial_date, professional_id = "")
        initial_date = AppointmentsExporterHelper.week_start(initial_date)
        appointments = Appointment.where(date_time: initial_date.beginning_of_day..((initial_date + 6.days).end_of_day))

        if not professional_id.empty?
            professional = Professional.find(professional_id)
            appointments = appointments.where(professional: professional)
        end

        appointments
    end

    def self.find_by_patient_name(name)
        Appointment.where(name: name)
    end

    def self.find_by_patient_surname(name)
        Appointment.where(surname: name)
    end

    def self.find_by_professional_name(name)
        appointments = Professional.find_by_name(name).collect{ | professional | professional.appointments }.flatten
        Appointment.where(id: appointments.map(&:id))
    end
    
    def self.ransackable_scopes(auth_object = nil)
        [:date, :week]
    end

    def as_json(options = {})
        {
            id: self.id,
            patient: self.name + " " + self.surname,
            professional: self.professional_name,
            date: self.date,
            hour: self.hour
        }
    end

    singleton_class.alias_method :date, :all_appointments_by_date
    singleton_class.alias_method :week, :all_appointments_by_week
end
