class UsersAdminController < ApplicationController

  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    if @user
      @posts = @user.posts.order(created_at: :desc)
    end
    if @posts
      @comment = current_user.comments.build
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @user.avatar = nil
      if @user.save
        format.html { redirect_to users_admin_index_path, notice: 'User was successfully updated.' }
      else
        format.html { redirect_to users_admin_index_path, notice: 'User was successfully updated.' }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_admin_index_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {}).permit(:username, :email, :password, :password_confirmation, :avatar)
    end

    # Only allow admin user to access users admin
    def verify_admin
      unless current_user.admin?
        flash[:danger] = "Access denied"
        redirect_to root_path
      end
    end
end
