class AppointmentsController < ApplicationController

  include ApplicationHelper
  before_action :set_professional
  before_action :set_appointment, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  def index
    begin
      start_date = Date.strptime(params[:q][:date_time_gteq], '%Y-%m-%d').beginning_of_day
      params[:q][:date_time_gteq] = start_date
    rescue
      start_date = nil
    end

    begin
      end_date = Date.strptime(params[:q][:date_time_lteq], '%Y-%m-%d').end_of_day
      params[:q][:date_time_lteq] = end_date
    rescue
      end_date = nil
    end

    if @professional
      @appointments = @professional.appointments
    else
      @appointments = Appointment.all
    end

    @q = @appointments.order(date_time: 'asc').ransack(params[:q])

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
      redirect_to route(appointment_path(@appointment)), notice: t('activerecord.successful.messages.created', model: t("activerecord.models.appointment"))
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to route(appointment_path(@appointment)), notice: t('activerecord.successful.messages.updated', model: t("activerecord.models.appointment"))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @appointment.finished?
      alert = t("appointment_finished")
    else
      @appointment.destroy
      notice = t("appointment_canceled")
    end

    redirect_to route(appointments_path), notice: notice, alert: alert
  end

  def cancel_all
    @professional.appointments.not_finished.destroy_all
    redirect_to professional_appointments_path, notice: t("appointments_canceled")
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