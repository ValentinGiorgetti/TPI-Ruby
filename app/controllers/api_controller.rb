class ApiController < ActionController::Base

    def get_professionals
        parameters = request.query_parameters

        if (parameters.size > 1) || (parameters.size == 1 && (!parameters[:id] && !parameters[:name]))
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        result = Professional.all

        if parameters[:id]
            result = result.where(id: parameters[:id])
        end

        if parameters[:name]
            result = Professional.find_by_name(parameters[:name])
        end
        
        render json: result, only: [:id, :name]
    end

    def get_appointments
        parameters = request.query_parameters

        render json: Appointment.not_finished and return if parameters.empty?
        if parameters.size > 2
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        if parameters.size == 1 && (!["date", "week", "id", "patient_name", "patient_surname", "professional_name"].include?(parameters.keys[0]))
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        if parameters.size == 2 && (!parameters[:start_date] && !parameters[:end_date])
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        render json: Appointment.where(id: parameters[:id]) and return if parameters[:id]

        appointments = nil

        begin
            if params[:start_date]
                start_date = Appointment.check_date_string(params[:start_date])

                end_date = Appointment.check_date_string(params[:end_date])

                appointments = Appointment.between_dates(start_date, end_date)
            else 
                if parameters[:date] || parameters[:week]
                    date = Appointment.check_date_string(params[:date] ? parameters[:date] : parameters[:week])

                    appointments = params[:date] ? Appointment.all_appointments_by_date(date) : appointments = Appointment.all_appointments_by_week(date)
                end
            end
        rescue
            render json: { "description": "Bad parameters" }, status: 400 and return
        end        
        # "patient_name", "patient_surname", "professional_name"
        if not appointments 
            appointments = Appointment.find_by_patient_name(parameters[:patient_name]) if parameters[:patient_name]
            appointments = Appointment.find_by_patient_surname(parameters[:patient_surname]) if parameters[:patient_surname] 
            appointments = Appointment.find_by_professional_name(parameters[:professional_name]) if parameters[:professional_name]
        end

        render json: appointments
    end

end