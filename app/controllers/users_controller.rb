class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :set_roles
  load_and_authorize_resource

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    notice = ""

    if @user.email != current_user.email
      @user.destroy
      notice = "User was successfully destroyed"
    else
      notice = "You can't delete your own user"
    end

    respond_to do |format|
      format.html { redirect_to users_url, notice: notice }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_roles
      @roles = [ ["Administrator", "admin"],
                 ["Consultant", "consultant"],
                 ["Assistant", "assistant"] ]
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :surname, :email, :password, :role)
    end
end
