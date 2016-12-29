class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :verify_user!, only: [:show, :edit, :following, :followers]
  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t :mail_info_mess
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user = User.find_by id: params[:id]
    if @user != nil && @user.update_attributes(user_params)
      flash[:success] = t :user_edit_profile_updated
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = t :user_deleted
    redirect_to users_url
  end

  private

  def user_params
      params.require(:user).permit(:name, :email, :password,
        :password_confirmation)
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless @user != nil && current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def verify_user!
    @user = User.find_by id: params[:id] || params[:user_id]
    if @user.nil?
      flash[:danger] = t :user_nil_mess
      redirect_to root_url
    end
  end
end
