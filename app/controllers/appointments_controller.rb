class AppointmentsController < ApplicationController

  include ApplicationHelper
  before_action :set_professional
  before_action :set_appointment, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  def index
    begin
      start_date = Date.strptime(params[:q][:date_time_gteq], '%Y-%m-%d')
    rescue
      start_date = nil
    end

    begin
      end_date = Date.strptime(params[:q][:date_time_lteq], '%Y-%m-%d')
    rescue
      end_date = nil
    end

    if @professional
      @appointments = @professional.appointments
    else
      @appointments = Appointment.not_finished
    end

    @q = @appointments.between_dates(start_date, end_date).order(date_time: 'asc').ransack(params[:q] ? params[:q].except(:date_time_lteq).except(:date_time_gteq) : params[:q])
    @appointments = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @appointment = Appointment.new
    if @professional
      @professionals = @professional
    else
      @professionals = Professional.all
    end
  end

  def edit
  end

  def create  
    @appointment = Appointment.new(appointment_params)
    @professionals = Professional.all
    
    if @appointment.save
      redirect_to route(appointment_path(@appointment)), notice: "Appointment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to route(appointment_path(@appointment)), notice: "Appointment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @appointment.finished?
      alert = "Appointment is finished"
    else
      @appointment.destroy
      notice = "Appointment was successfully canceled."
    end

    redirect_to route(appointments_path), notice: notice, alert: alert
  end

  def cancel_all
    @professional.appointments.not_finished.destroy_all
    redirect_to professional_appointments_path, notice: "Appointments were successfully canceled"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      if @appointment && @appointment.id && Appointment.find_by_id(@appointment.id).finished?
        tmp = params.require(:appointment).permit(:name, :surname, :phone, :notes, :professional_id)
      else
        tmp = params.require(:appointment).permit(:name, :surname, :phone, :notes, :date_time, :professional_id)
        tmp["date_time(5i)"] = "0"  # pone los minutos en 0
      end
      tmp
    end

    def set_professional
      if params[:professional_id]
        @professional = Professional.find(params[:professional_id])
      else
        @professional = nil
      end
    end
end