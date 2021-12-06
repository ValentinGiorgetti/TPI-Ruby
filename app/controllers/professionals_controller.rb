class ProfessionalsController < ApplicationController

  before_action :set_professional, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /professionals
  def index
    @professionals = Professional.all
  end

  # GET /professionals/1
  def show
  end

  # GET /professionals/new
  def new
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
  end

  # POST /professionals
  def create
    @professional = Professional.new(professional_params)

    respond_to do |format|
      if @professional.save
        format.html { redirect_to @professional, notice: "Professional was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professionals/1
  def update
    respond_to do |format|
      if @professional.update(professional_params)
        format.html { redirect_to @professional, notice: "Professional was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professionals/1
  def destroy
    if @professional.has_pending_appointments?
      alert = "The professional can't be deleted because of pending appointment/s"
    else
      @professional.destroy
      notice = "The professional and his/her appointment/s were successfully destroyed"
    end
    respond_to do |format|
      format.html { redirect_to professionals_url, notice: notice, alert: alert }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def professional_params
      params.require(:professional).permit(:name)
    end
end
