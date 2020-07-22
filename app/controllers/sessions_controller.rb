class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user &.authenticate params[:session][:password]
      log_in user
      is_remember_user? user
      flash[:success] = t ".create.success_login_notify"
      redirect_to user
    else
      flash[:danger] = t ".create.faild_login_notify"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
