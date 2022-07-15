class ApiController < ActionController::Base

    def get_professionals
        render json: Professional.all, only: [:name]
    end

    def get_appointments
        parameters = request.query_parameters
        
        if (parameters.size > 1) || (parameters.size == 1 && (!parameters[:date] && !parameters[:week]))
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        appointments = Appointment.not_finished

        render json: appointments and return if parameters.empty?

        begin
            date = Date.parse(params[:date] ? parameters[:date] : parameters[:week])
        rescue
            render json: { "description": "Bad parameters" }, status: 400 and return
        end
        
        if params[:date]
            appointments = appointments.where(date_time: date.all_day)
        else
            initial_date = AppointmentsExporterHelper.week_start(date)
            appointments = appointments.where(date_time: initial_date.beginning_of_day..((initial_date + 6.days).end_of_day))
        end

        render json: appointments
    end

end