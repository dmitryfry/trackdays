class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to profile_path, notice: "Регистрация прошла успешно! Добро пожаловать в сообщество."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = current_user || User.first
    redirect_to login_path unless @user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :telegram_username, :bio)
  end
end
