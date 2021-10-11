module Polycon
    module Exceptions
        autoload :EmptyNameError, 'polycon/exceptions/polyconexception'
        autoload :InvalidNameError, 'polycon/exceptions/polyconexception'
        autoload :EmptySurnameError, 'polycon/exceptions/polyconexception'
        autoload :InvalidSurnameError, 'polycon/exceptions/polyconexception'
        autoload :EmptyPhoneError, 'polycon/exceptions/polyconexception'
        autoload :InvalidPhoneError, 'polycon/exceptions/polyconexception'
        autoload :InvalidDateTimeError, 'polycon/exceptions/polyconexception'
        autoload :OldDateTimeError, 'polycon/exceptions/polyconexception'
        autoload :InvalidDateError, 'polycon/exceptions/polyconexception'
        autoload :AppointmentAlreadyExistsError, 'polycon/exceptions/polyconexception'
        autoload :AppointmentDoesntExistError, 'polycon/exceptions/polyconexception'
        autoload :AppointmentCantBeCanceled, 'polycon/exceptions/polyconexception'
        autoload :AppointmentCantBeRescheduled, 'polycon/exceptions/polyconexception'
        autoload :ProfessionalAlreadyExistsError, 'polycon/exceptions/polyconexception'
        autoload :ProfessionalDoesntExistError, 'polycon/exceptions/polyconexception'
        autoload :ProfessionalCantBeDeletedError, 'polycon/exceptions/polyconexception'
    end
end