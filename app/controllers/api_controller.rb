class ApiController < ActionController::Base

    def get_professionals
        parameters = request.query_parameters

        if (parameters.size > 1) || (parameters.size == 1 && (!parameters[:id]))
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        result = Professional.all

        if parameters[:id]
            result = result.where(id: parameters[:id])
        end
        
        render json: result, only: [:id, :name]
    end

    def get_appointments
        parameters = request.query_parameters
        
        if (parameters.size > 1) || (parameters.size == 1 && (!parameters[:date] && !parameters[:week] && !parameters[:id]))
            render json: { "description": "Bad parameters" }, status: 400 and return
        end

        render json: Appointment.not_finished and return if parameters.empty?

        render json: Appointment.where(id: parameters[:id]) and return if parameters[:id]

        begin
            date_string = params[:date] ? parameters[:date] : parameters[:week]
            raise ArgumentError if date_string.split("-").map{|number| number.scan(/\D/).empty?}.include?(false)
            date = Date.strptime(date_string, '%d-%m-%Y')
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