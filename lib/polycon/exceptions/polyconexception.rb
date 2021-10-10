module Polycon

    module Exceptions

        class PolyconException < StandardError; end

        class EmptyNameError < PolyconException
            def initialize
                super("Se ingresó un nombre vacío")
            end
        end

        class InvalidNameError < PolyconException
            def initialize
                super("Se ingresó un nombre inválido")
            end
        end

        class EmptySurnameError < PolyconException
            def initialize
                super("Se ingresó un apellido vacío")
            end
        end

        class InvalidSurnameError < PolyconException
            def initialize
                super("Se ingresó un apellido inválido")
            end
        end

        class EmptyPhoneError < PolyconException
            def initialize
                super("Se ingresó un número de teléfono vacío")
            end
        end    
        
        class InvalidPhoneError < PolyconException
            def initialize
                super("Se ingresó un número de teléfono inválido")
            end
        end
        
        class InvalidDateTimeError < PolyconException
            def initialize
                super("Se ingresó una fecha y hora inválida")
            end
        end

        class OldDateTimeError < PolyconException
            def initialize
                super("Se ingresó una fecha y hora que ya pasó")
            end
        end

        class InvalidDateError < PolyconException
            def initialize
                super("Se ingresó una fecha inválida")
            end
        end

        class ProfessionalAlreadyExistsError < PolyconException
            def initialize
                super("Ya existe un profesional con ese nombre")
            end
        end

        class ProfessionalDoesntExistError < PolyconException
            def initialize
                super("No existe un profesional con ese nombre")
            end
        end

        class ProfessionalCantBeDeletedError < PolyconException
            def initialize
                super("El profesional no puede ser eliminado ya que tiene consultas pendientes")
            end
        end

        class AppointmentAlreadyExistsError < PolyconException
            def initialize
                super("Ya existe un appointment en esa fecha para ese profesional")
            end
        end

        class AppointmentDoesntExistError < PolyconException
            def initialize
                super("No se encontró el appointment")
            end
        end

        class AppointmentCantBeCanceled < PolyconException
            def initialize
                super("No se puede cancelar el appointment ya que el mismo ya fue realizado")
            end
        end

    end

end