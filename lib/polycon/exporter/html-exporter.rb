require "erb"

module Polycon

    module Exporter

        class HTMLExporter

            def self.crear_hash_horas()
                hash = {}
                for i in 9..21 do
                    hash["#{i}:00"] = []
                end
                hash
            end

            def self.crear_hash_dias(initial_date)
                hash = {}
                for i in 1..7 do
                    hash[initial_date.strftime("%Y-%m-%d")] = crear_hash_horas()
                    initial_date = initial_date.next_day
                end
                hash
            end

            def self.export_appointments_by_date(appointments, date, professional_name = nil)
                hash = crear_hash_horas()
                appointments.each do | appointment |
                    hora = appointment.date_time.strftime("%H:%M")
                    hash[hora] << appointment
                end

                tempalte_path = File.join("#{Dir.pwd}", "lib", "polycon", "exporter", "template-por-dia.html.erb")
                template = ERB.new(File.read(tempalte_path))
                File.open("#{Dir.home}/appointments.html", "w") do | file |
                    file.write(template.result_with_hash(date: date, appointments: hash, professional: professional_name))
                end
            end

            def self.export_appointments_by_week(appointments, initial_date, professional_name = nil)
                initial_date = Polycon::Helper::PolyconHelper.validate_date(initial_date)
                initial_date = Polycon::Helper::PolyconHelper.week_start(initial_date)
                
                hash = crear_hash_dias(initial_date)

                appointments.each do | appointment |
                    hora = appointment.date_time.strftime("%H:%M")
                    dia = appointment.date
                    hash[dia][hora] << appointment
                end

                tempalte_path = File.join("#{Dir.pwd}", "lib", "polycon", "exporter", "template-por-semana.html.erb")
                template = ERB.new(File.read(tempalte_path))
                File.open("#{Dir.home}/appointments.html", "w") do | file |
                    file.write(template.result_with_hash(appointments: hash, inicial: initial_date, horas: crear_hash_horas(), professional: professional_name))
                end
            end

        end

    end

end