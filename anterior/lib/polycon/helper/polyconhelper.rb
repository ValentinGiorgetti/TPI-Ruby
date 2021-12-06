require "date"

module Polycon

    module Helper

        class PolyconHelper
            
            def self.validate_date_time(date_time)
                begin
                    date_time = DateTime.strptime(date_time, "%Y-%m-%d %H:%M")
                    hour = date_time.strftime("%H:%M")
                    if (not Polycon::Models::Appointment.valid_hours().include?(hour))
                        raise Polycon::Exceptions::InvalidDateTimeError.new()
                    end
                rescue
                    begin
                        date_time = DateTime.strptime(date_time, "%Y-%m-%d_%H-%M")
                        hour = date_time.strftime("%H:%M")
                        if (not Polycon::Models::Appointment.valid_hours().include?(hour))
                            raise Polycon::Exceptions::InvalidDateTimeError.new()
                        end
                    rescue
                        raise Polycon::Exceptions::InvalidDateTimeError.new()
                    end
                end
                date_time
            end

            def self.validate_creation_date_time(date_time)
                date_time = validate_date_time(date_time)
                if (date_time < DateTime.now)
                    raise Polycon::Exceptions::OldDateTimeError.new()
                end
                date_time
            end

            def self.validate_date(date)
                 begin
                    date = DateTime.strptime(date, "%Y-%m-%d")
                 rescue
                    raise Polycon::Exceptions::InvalidDateError.new()
                 end
                 date
            end

            def self.week_start(date) # retorna la fecha del lunes de la semana recibida por parámetro
                date - (date.wday - 1) % 7
            end

            def self.validate_name(name)
                name = name.strip
                if name.empty?
                    raise Polycon::Exceptions::EmptyNameError.new()
                end
                if not name.match(/^[a-z A-Z]+$/)
                    raise Polycon::Exceptions::InvalidNameError.new()
                end
                name
            end

            def self.validate_surname(surname)
                surname = surname.strip
                if surname.empty?
                    raise Polycon::Exceptions::EmptySurnameError.new()
                end
                if not surname.match(/^[a-z A-Z]+$/)
                    raise Polycon::Exceptions::InvalidSurnameError.new()
                end
                surname
            end

            def self.validate_phone(phone)
                if phone.strip! == ""
                    raise Polycon::Exceptions::EmptyPhoneError.new()
                end
                if not phone.match(/^[\d]+$/)
                    raise Polycon::Exceptions::InvalidPhoneError.new()
                end
                phone
            end

        end

    end
    
end