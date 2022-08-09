class ApiController < ActionController::Base

    def check_positive_integer(number)
        (number.to_i.to_s == number) && (number.to_i >= 0)
    end

    def check_parameters(parameters)
        if (parameters.empty?)
            return false
        end

        if parameters[:page] && !check_positive_integer(parameters[:page])
            pp 11
            return false
        end

        if parameters[:id] && !check_positive_integer(parameters[:id])
            return false
        end

        if (parameters.size == 1) && (!parameters[:id] && !parameters[:page])
            return false
        end

        if parameters.size > 1 && (parameters[:id] || !parameters[:page])
            return false
        end

        true
    end

    def get_professionals
        parameters = request.query_parameters

        if not check_parameters(parameters)
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        if parameters.size > 2
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        if (parameters.size == 2) && (!(parameters[:name] && parameters[:page]))
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        result = nil

        if parameters[:id]
            result = Professional.find_by(id: parameters[:id])
            render json: { "description": "Not found" }, status: 404 and return if not result
        end

        if parameters[:name]
            result = Professional.find_by_name(parameters[:name]).page(parameters[:page])
        end

        if not result
            result = Professional.all.page(parameters[:page])
        end

        render json: result, only: [:id, :name]
    end

    def get_appointments
        parameters = request.query_parameters

        if not check_parameters(parameters)
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        if parameters.size > 3
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        if parameters.size == 2  && (!["date", "week", "patient_name", "patient_surname", "professional_name"].include?(parameters.keys.excluding("page")[0]))
            render json: { "description": "Bad parameters" }, status: 400 and return
        end
        
        if parameters.size == 3 && (!parameters[:start_date] || !parameters[:end_date])
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        result = nil

        if parameters[:id]
            result = Appointment.find_by(id: parameters[:id])
            if not result
                render json: { "description": "Not found" }, status: 404 and return
            else 
                render json: result and return
            end
        end

        begin
            if params[:start_date]
                start_date = Appointment.check_date_string(params[:start_date])

                end_date = Appointment.check_date_string(params[:end_date])

                result = Appointment.between_dates(start_date, end_date)
            else 
                if parameters[:date] || parameters[:week]
                    date = Appointment.check_date_string(params[:date] ? parameters[:date] : parameters[:week])

                    result = params[:date] ? Appointment.all_appointments_by_date(date) : Appointment.all_appointments_by_week(date)
                end
            end
        rescue
            render json: { "description": "Bad parameters" }, status: 400 and return
        end        

        if not result 
            result = Appointment.find_by_patient_name(parameters[:patient_name]) if parameters[:patient_name]
            result = Appointment.find_by_patient_surname(parameters[:patient_surname]) if parameters[:patient_surname] 
            result = Appointment.find_by_professional_name(parameters[:professional_name]) if parameters[:professional_name]
        end

        render json: result.page(parameters[:page])
    end

end