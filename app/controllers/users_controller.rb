class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    admin_only
    @users = User.students.page params[:page]
  end

  # GET /users/1/edit
  def edit
    self_or_admin_only
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    self_or_admin_only

    attrs = user_params
    attrs[:same_sex_room] = attrs[:same_sex_cell] if attrs[:same_sex_cell] == "1"
    @user.place&.touch if attrs[:same_sex_room] || attrs[:same_sex_cell]

    respond_to do |format|
      if @user.update(attrs)
        red = current_user.admin ? users_path : "/"
        target = current_user.admin ? "Uživatel" : "Váš profil"
        format.html { redirect_to red, notice: target + ' byl úspěšně změněn.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:allow_alliance, :allow_room_switch, :move_with_alliance, :male, :same_sex_room, :same_sex_cell, :allow_share_info, :note)
    end

    def self_or_admin_only
      unless(current_user.admin || current_user.id == @user.id)
          unauthorized
      end
    end

end
