require "erb"

module Polycon

    module Exporter

        class HTMLExporter

            def self.create_hours_hash()
                hash = {}
                for i in 9..21 do
                    hash["#{i}:00"] = []
                end
                hash
            end

            def self.create_days_hash(initial_date)
                hash = {}
                for i in 1..7 do
                    hash[initial_date.strftime("%Y-%m-%d")] = create_hours_hash()
                    initial_date = initial_date.next_day
                end
                hash
            end

            def self.export_appointments_by_date(appointments, date, professional_name = nil)
                hash = create_hours_hash()
                appointments.each do | appointment |
                    hour = appointment.date_time.strftime("%H:%M")
                    hash[hour] << appointment
                end

                template_path = File.join("#{Dir.pwd}", "lib", "polycon", "exporter", "appointments-by-date-template.html.erb")
                template = ERB.new(File.read(template_path))
                File.open("#{Dir.home}/appointments.html", "w") do | file |
                    file.write(template.result_with_hash(date: date, appointments: hash, professional_name: professional_name))
                end
            end

            def self.export_appointments_by_week(appointments, initial_date, professional_name = nil)
                initial_date = Polycon::Helper::PolyconHelper.validate_date(initial_date)
                initial_date = Polycon::Helper::PolyconHelper.week_start(initial_date)
                
                hash = create_days_hash(initial_date)

                appointments.each do | appointment |
                    hour = appointment.date_time.strftime("%H:%M")
                    day = appointment.date
                    hash[day][hour] << appointment
                end

                template_path = File.join("#{Dir.pwd}", "lib", "polycon", "exporter", "appointments-by-week-template.html.erb")
                template = ERB.new(File.read(template_path))
                File.open("#{Dir.home}/appointments.html", "w") do | file |
                    file.write(template.result_with_hash(appointments: hash, initial_date: initial_date, hours: create_hours_hash(), professional_name: professional_name))
                end
            end

            def self.get_day_of_week(day)
                day_name = Date.strptime(day, "%Y-%m-%d").strftime("%A")

                {"Monday" => "Lunes",
                 "Tuesday" => "Martes",
                 "Wednesday" => "Miércoles",
                 "Thursday" => "Jueves",
                 "Friday" => "Viernes",
                 "Saturday" => "Sábado",
                 "Sunday" => "Domingo"}[day_name]
            end

        end

    end

end