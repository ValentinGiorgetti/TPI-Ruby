require "date"

module Polycon

    module Models

        class Appointment

            attr_accessor :date_time, :professional, :name, :surname, :phone, :notes

            def self.create(date_time, professional, name, surname, phone, notes = nil)
                Polycon::Helper::PolyconHelper.validate_creation_date_time(date_time)
                new(date_time, professional, name, surname, phone, notes)
            end

            def initialize(date_time, professional, name, surname, phone, notes = nil)
                self.date_time = date_time
                self.professional = professional
                self.name = name
                self.surname = surname
                self.phone = phone
                @notes = notes
            end

            def finished?
                @date_time < DateTime.now()
            end

            def date_time=(date_time)
                @date_time = Polycon::Helper::PolyconHelper.validate_date_time(date_time)
            end

            def professional=(professional)
                @professional = Polycon::Models::Professional.load(professional)
            end

            def name=(name)
                @name = Polycon::Helper::PolyconHelper.validate_name(name)
            end

            def surname=(surname)
                @surname = Polycon::Helper::PolyconHelper.validate_surname(surname)
            end

            def phone=(phone)
                @phone = Polycon::Helper::PolyconHelper.validate_phone(phone)
            end

            def save()
                if professional.has_appointment?(date_time)
                    raise Polycon::Exceptions::AppointmentAlreadyExistsError.new()
                end
                Polycon::Persistance::PolyconFile.save_appointment(self)
            end

            def update()
                Polycon::Persistance::PolyconFile.save_appointment(self)
            end

            def self.load(date_time, professional_name)
                Polycon::Persistance::PolyconFile.load_appointment(professional_name, date_time)
            end

            def self.exists?(professional, date_time)
                professional.has_appointment?(date_time)
            end

            def self.valid_hours()
                (9..21).collect { | hour | "#{hour}:00" }
            end

            def reschedule(new_date_time)
                if finished?
                    raise Polycon::Exceptions::AppointmentCantBeRescheduled.new()
                end
                new_date_time = Polycon::Helper::PolyconHelper.validate_creation_date_time(new_date_time)
                if Appointment.exists?(@professional, new_date_time)
                    raise Polycon::Exceptions::AppointmentAlreadyExistsError.new()
                end
                Polycon::Persistance::PolyconFile.reschedule_appointment(self, new_date_time)
            end

            def edit(**options)
                options.each do | option, value |
                    send("#{option}=", value)
                end
            end

            def to_s
                return "Appointment de la fecha #{@date_time.strftime("%Y-%m-%d a las %H:%M")}, paciente #{@name}"
            end

            def cancel()
                if finished?
                    raise Polycon::Exceptions::AppointmentCantBeCanceled.new()
                end
                Polycon::Persistance::PolyconFile.delete_appointment(self)
            end

            def date
                @date_time.strftime("%Y-%m-%d")
            end

            def hour
                @date_time.strftime("%H:%M")
            end
                        
        end

    end

end