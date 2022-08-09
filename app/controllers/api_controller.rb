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
        
        if (parameters.size > 2) || (parameters.size == 1 && (!parameters[:date] && !parameters[:week] && !parameters[:id]))
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        if parameters.size == 2 && (!parameters[:start_date] && !parameters[:end_date])
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        render json: Appointment.where(id: parameters[:id]) and return if parameters[:id]

        begin
            if params[:start_date]
                start_date = Appointment.check_date_string(params[:start_date])

                end_date = Appointment.check_date_string(params[:end_date])

                appointments = Appointment.between_dates(start_date, end_date)
            else
                date = Appointment.check_date_string(params[:date] ? parameters[:date] : parameters[:week])

                appointments = params[:date] ? Appointment.all_appointments_by_date(date) : appointments = Appointment.all_appointments_by_week(date)
            end
        rescue
            render json: { "description": "Bad parameters" }, status: 400 and return
        end        

        render json: appointments
    end

end