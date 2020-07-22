class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :find_user, except: %i(new create index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.paginate.items_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".please_check_your_email"
      redirect_to root_url
    else
      flash[:danger] = t ".faild_notify"
      render :new
    end
  end

  def show
    @microposts = @user.microposts.page(params[:page])
                       .per Settings.paginate.items_per_page
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".success_update"
      redirect_to @user
    else
      flash[:danger] = t ".faild_update"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
      redirect_to users_url
    else
      flash.now[:danger] = t ".delete_user_faild"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".show.invalid_user_notify"
  end
end
