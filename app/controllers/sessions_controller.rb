class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      is_activated? user
    else
      flash[:danger] = t ".create.faild_login_notify"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def is_activated? user
    if user.activated?
      log_in user
      is_remember_user? user
      redirect_back_or user
    else
      flash[:warning] = t ".please_check_email"
      redirect_to root_url
    end
  end
end
