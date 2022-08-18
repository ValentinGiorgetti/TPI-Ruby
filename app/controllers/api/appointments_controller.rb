class Api::AppointmentsController < ApiController

    def list
        params.permit(:name_cont, :surname_cont, :professional_name_cont, :start_date, :end_date, :date, :week, :page)
        
        params[:date_time_gteq] = check_date_string(params[:start_date]).beginning_of_day if params[:start_date]
        params[:date_time_lteq] = check_date_string(params[:end_date]).end_of_day if params[:end_date]
        params[:date] = check_date_string(params[:date]) if params[:date]
        params[:week] = check_date_string(params[:week]) if params[:week]

        super
    end

end