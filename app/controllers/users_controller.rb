class UsersController < ApplicationController
  before_action :set_roles, :set_user
  load_and_authorize_resource

  def new_users
    @users = User.where(new_user: true).page(params[:page])
    render :index
  end

  # GET /users
  def index
    @users = User.all.page(params[:page])
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

    if @user.save
      redirect_to @user, notice: "User was successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params.compact_blank)
      if current_user.role == "administrator" 
        @user.update(new_user: false)
        redirect_to @user, notice: "User was successfully updated"
      else
        redirect_to '/my_profile', notice: "User was successfully updated"
      end
    else
      render :edit
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

    redirect_to users_url, notice: notice
  end

  private
    def set_user
      @user = params[:id] ? User.find(params[:id]) : current_user
    end

    def set_roles
      if current_user.role == "administrator"
        @roles = [ ["Administrator", "administrator"],
                  ["Consultant", "consultant"],
                  ["Assistant", "assistant"] ]
      else
        @roles = [ [current_user.role.capitalize, current_user.role] ]
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :surname, :email, :password, :role)
    end
end
