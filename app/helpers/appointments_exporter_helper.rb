module AppointmentsExporterHelper

    def self.create_hours_hash()
        hash = {}
        Appointment.valid_hours().each { | hour | hash[hour] = [] }
        hash
    end

    def self.create_days_hash(initial_date)
        hash = {}

        for i in 1..7 do
            hash[initial_date.strftime("%d-%m-%Y")] = create_hours_hash()
            initial_date = initial_date.next_day
        end

        hash
    end

    def self.week_start(date) # retorna la fecha del lunes de la semana recibida por parámetro
        date - (date.wday - 1) % 7
    end

    def self.export_appointments_by_date(appointments, date, professional_name = nil)
        hours_hash = create_hours_hash()
        appointments.each do | appointment |
            hour = appointment.hour
            hours_hash[hour] << appointment
        end

        template_path = File.join("#{Dir.pwd}", "app", "views", "appointments_exporter", "appointments-by-date-template.html.erb")
        template = ERB.new(File.read(template_path))
        File.open(file_path(), "w") do | file |
            file.write(template.result_with_hash(date: date, appointments: hours_hash, professional_name: professional_name))
        end
    end

    def self.export_appointments_by_week(appointments, initial_date, professional_name = nil)
        
        initial_date = week_start(initial_date)
        days_hash = create_days_hash(initial_date)

        appointments.each do | appointment |
            hour = appointment.hour
            day = appointment.date
            days_hash[day][hour] << appointment
        end

        template_path = File.join("#{Dir.pwd}", "app", "views", "appointments_exporter", "appointments-by-week-template.html.erb")
        template = ERB.new(File.read(template_path))
        File.open(file_path(), "w") do | file |
            file.write(template.result_with_hash(appointments: days_hash, initial_date: initial_date, hours: create_hours_hash(), professional_name: professional_name))
        end
    end

    def self.get_day_of_week(day)
        I18n.l(day, format: "%A").capitalize
    end

    def self.file_path()
        File.join("#{Dir.home}", "appointments.html")
    end
end
