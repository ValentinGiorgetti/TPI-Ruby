class AppointmentsExporterController < ApplicationController
  before_action :authenticate_user!

  def index
    @professionals = Professional.all
  end

  def submit
    @form_data = FormData.new(form_data_params())
    @professionals = Professional.all
    if @form_data.valid?
      if @form_data.filter_by == "Date"
        appointments = Appointment.all_appointments_by_date(@form_data.date, @form_data.professional_id)
        AppointmentsExporterHelper.export_appointments_by_date(appointments, @form_data.date, @form_data.professional_id)
      else
        appointments = Appointment.all_appointments_by_week(@form_data.date, @form_data.professional_id)
        AppointmentsExporterHelper.export_appointments_by_week(appointments, @form_data.date, @form_data.professional_id)
      end
      send_file AppointmentsExporterHelper.file_path(), type: 'image/jpeg'
    else
      render :index
    end
  end

  class FormData
    include ActiveModel::Validations
  
    attr_accessor :date, :filter_by, :professional_id
  
    validates :date, :filter_by, presence: true

    def initialize(params)
      @date = Date.new params["date(1i)"].to_i, params["date(2i)"].to_i, params["date(3i)"].to_i
      @filter_by = params[:filter_by]
      @professional_id = params[:professional_id]
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def form_data_params
      params.require(:form_data).permit(:date, :filter_by, :professional_id)
    end
end
