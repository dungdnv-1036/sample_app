class FollowController < ApplicationController
  before_action :logged_in_user, :find_user

  def following
    @users = @user.following.page(params[:page])
                  .per Settings.paginate.items_per_page
    render "users/show_follow"
  end

  def followers
    @users = @user.followers.page(params[:page])
                  .per Settings.paginate.items_per_page
    render "users/show_follow"
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".show.invalid_user_notify"
    redirect_to root_path
  end
end
