class AppointmentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_professional
  before_action :set_appointment, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /appointments or /appointments.json
  def index
    if @professional
      @appointments = @professional.appointments
    else
      @appointments = Appointment.order(date_time: 'desc')
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
    @url = appointment_path()
  end

  # POST /appointments or /appointments.json
  def create  
    @appointment = Appointment.new(appointment_params)
    @professionals = Professional.all
    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to @appointment, notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
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
      format.json { head :no_content }
    end
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
        @url = professional_appointments_url(@professional)
      else
        @professional = nil
        @url = appointments_url()
      end
    end

    def appointments_path(professional_id = nil)
      if not professional_id
        "/appointments"
      else
        "/professionals/#{professional_id}/appointments"
      end
    end
end
