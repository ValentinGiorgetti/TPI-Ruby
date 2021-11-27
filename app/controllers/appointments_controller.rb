class AppointmentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_professional
  before_action :set_appointment, only: %i[ show edit update destroy ]
  load_and_authorize_resource :except => [:cancel_all]

  helper_method :route

  # GET /appointments or /appointments.json
  def index
    if @professional
      @appointments = @professional.appointments.order(date_time: 'desc')
    else
      @appointments = Appointment.order(date_time: 'desc')
    end

    if request.post?
      date = request.params["anything"]["date"]
      if !date.empty?
        date = Date.parse(date)
        @appointments = @appointments.where(date_time: date.beginning_of_day..date.end_of_day)
      end
    end
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
    if @professional
      @professionals = @professional
    else
      @professionals = Professional.all
    end
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create  
    @appointment = Appointment.new(appointment_params)
    @professionals = Professional.all
    respond_to do |format|
      if @appointment.save
        format.html { redirect_to route(appointment_path(@appointment)), notice: "Appointment was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to route(appointment_path(@appointment)), notice: "Appointment was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    if @appointment.finished?
      alert = "No se puede cancelar el appointment ya que el mismo ya fue realizado"
    else
      @appointment.destroy
      notice = "Appointment was successfully destroyed."
    end

    respond_to do |format|
      format.html { redirect_to appointments_url, notice: notice, alert: alert }
    end
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

    def route(string)
      professional = request.params[:professional_id]
      if professional
        "/professionals/#{professional}#{string}"
      else
        string
      end
    end
end
