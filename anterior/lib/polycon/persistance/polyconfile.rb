require "date"

module Polycon

    module Persistance

        class PolyconFile

            Dir.mkdir("#{Dir.home}/.polycon") unless File.exists?("#{Dir.home}/.polycon")

            def self.save_professional(professional)
                Dir.mkdir(professional_directory(professional))
            end

            def self.delete_professional(professional)
                FileUtils.rm_rf(professional_directory(professional))
            end

            def self.exist_professional?(professional_name)
                Dir.exist?("#{base_route()}#{professional_name}")
            end

            def self.rename_professional(professional, new_name)
                FileUtils.move(professional_directory(professional), "#{base_route()}#{new_name}")
            end

            def self.load_professionals()
                Dir.children("#{base_route()}").collect { | professional | Polycon::Models::Professional.new(professional) }
            end

            def self.save_appointment(appointment)
                File.open(appointment_file_name(appointment), "w") do | archivo |
                    archivo << (appointment.surname + "\n")
                    archivo << (appointment.name + "\n")
                    archivo << (appointment.phone + "\n")
                    if appointment.notes
                        archivo << (appointment.notes)
                    else
                        archivo << " "
                    end
                end                
            end

            def self.reschedule_appointment(appointment, new_date_time)
                old_date_time = appointment.date_time.strftime("%Y-%m-%d_%H-%M")
                new_date_time = new_date_time.strftime("%Y-%m-%d_%H-%M")
                old_route = "#{base_route()}#{appointment.professional.name}/#{old_date_time}.paf"
                new_route = "#{base_route()}#{appointment.professional.name}/#{new_date_time}.paf"
                FileUtils.move(old_route, new_route)
            end

            def self.load_appointment(professional_name, date_time)
                date_time = Polycon::Helper::PolyconHelper.validate_date_time(date_time).strftime("%Y-%m-%d_%H-%M")
                professional_name = Polycon::Helper::PolyconHelper.validate_name(professional_name)
                Polycon::Models::Professional.load(professional_name)
                appointment = nil
                begin
                    File.open("#{base_route()}#{professional_name}/#{date_time}.paf", "r") do | archivo |
                        surname = archivo.gets.chomp
                        name = archivo.gets.chomp
                        phone = archivo.gets.chomp
                        notes = archivo.gets.chomp
                        appointment = Polycon::Models::Appointment.new(date_time, professional_name, name, surname, phone, notes)
                    end
                rescue
                    raise Polycon::Exceptions::AppointmentDoesntExistError.new()
                else
                    return appointment
                end
            end

            def self.professional_appointments_list(professional)
                Dir.children(professional_directory(professional)).collect do | appointment | 
                    date_time = File.basename(appointment, ".paf")
                    load_appointment(professional.name, date_time)
                end
            end

            def self.delete_appointment(appointment)
                File.delete(appointment_file_name(appointment))
            end

            def self.appointment_file_name(appointment)
                "#{base_route()}#{appointment.professional.name}/#{appointment.date_time.strftime("%Y-%m-%d_%H-%M")}.paf"
            end

            def self.professional_directory(professional)
                "#{base_route()}#{professional.name}"
            end

            def self.base_route()
                "#{Dir.home}/.polycon/"
            end

        end

    end

end