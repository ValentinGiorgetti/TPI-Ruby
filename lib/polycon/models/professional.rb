module Polycon

    module Models

        class Professional

            attr_reader :name

            def initialize(name)
                self.name = name
            end

            def name=(name)
                @name = Polycon::Helper::PolyconHelper.validate_name(name)
            end

            def self.create(name)
                new(name)
            end

            def to_s()
                return "Profesional con nombre '#{@name}'"
            end

            def save()
                if Professional.exist?(@name)
                    raise Polycon::Exceptions::ProfessionalAlreadyExistsError.new()
                end
                Polycon::Persistance::PolyconFile.save_professional(self)
            end

            def self.load(professional)
                professional = Polycon::Helper::PolyconHelper.validate_name(professional)
                if not exist?(professional)
                    raise Polycon::Exceptions::ProfessionalDoesntExistError.new()
                end
                new(professional)
            end

            def rename(new_name)
                new_name = Polycon::Helper::PolyconHelper.validate_name(new_name)
                if Professional.exist?(new_name)
                    raise Polycon::Exceptions::ProfessionalAlreadyExistsError.new()
                end
                Polycon::Persistance::PolyconFile.rename_professional(self, new_name)
                @name = new_name
            end

            def self.list()
                Polycon::Persistance::PolyconFile.load_professionals
            end

            def has_appointments?
                not not_finished_appointments.empty?
            end

            def has_appointment?(date_time)
                appointments_list.detect{ | appointment | appointment.date_time == date_time }
            end

            def delete()
                if has_appointments?
                    raise Polycon::Exceptions::ProfessionalCantBeDeletedError.new()
                end
                Polycon::Persistance::PolyconFile.delete_professional(self)
            end

            def self.exist?(professional_name)
                Polycon::Persistance::PolyconFile.exist_professional?(professional_name)
            end

            def cancel_all()
                not_finished_appointments().each do | appointment |
                    appointment.cancel()
                end
            end

            def appointments_list(date = nil)
                list = Polycon::Persistance::PolyconFile.professional_appointments_list(self)
                if date
                    Polycon::Helper::PolyconHelper.validate_date(date)
                    list.select!{ | appointment | appointment.date == date }
                end
                list
            end

            def not_finished_appointments()
                appointments_list().select{ | appointment | not appointment.finished? }
            end

            def self.all_appointments_by_date(date, professional_name = nil)
                Polycon::Helper::PolyconHelper.validate_date(date)

                appointments = list().collect { | professional | professional.appointments_list(date) }

                appointments.flatten!

                if professional_name
                    professional = load(professional_name)
                    appointments.select!{ | appointment | appointment.professional.name == professional.name }
                end

                appointments
            end

            def self.all_appointments_by_week(initial_date, professional_name = nil)
                initial_date = Polycon::Helper::PolyconHelper.validate_date(initial_date)
                initial_date = Polycon::Helper::PolyconHelper.week_start(initial_date)
                
                appointments = []
                
                list().each do | professional |
                    date = initial_date
                    for i in 1..7 do
                        appointments << professional.appointments_list(date.strftime("%Y-%m-%d"))
                        date = date.next_day
                    end
                end
                
                appointments.flatten!

                if professional_name
                    professional = load(professional_name)
                    appointments.select!{ | appointment | appointment.professional.name == professional.name }
                end

                appointments
            end

        end

    end

end