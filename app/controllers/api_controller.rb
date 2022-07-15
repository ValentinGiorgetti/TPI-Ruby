class ApiController < ActionController::Base

    def get_professionals
        render json: Professional.all, only: [:name]
    end

    def get_appointments
        parameters = request.query_parameters
        
        if (parameters.size > 1) || (parameters.size == 1 && (!parameters[:date] && !parameters[:week]))
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        render json: Appointment.not_finished and return if parameters.empty?

        begin
            date = Date.parse(params[:date] ? parameters[:date] : parameters[:week])
        rescue
            render json: { "description": "Bad parameters" }, status: 400 and return
        end
        
        if params[:date]
            appointments = Appointment.all_appointments_by_date(date)
        else
            appointments = Appointment.all_appointments_by_week(date)
        end

        render json: appointments
    end

end