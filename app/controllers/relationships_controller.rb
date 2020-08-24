class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user.present?
      current_user.follow @user
    else
      flash[:danger] = t ".can_not_find_user"
    end
    respond_to :js
  end

  def destroy
    relationship = Relationship.find_by id: params[:id]
    if relationship.present?
      @user = relationship.followed
      current_user.unfollow @user
    else
      flash[:danger] = t ".can_not_find_user"
    end
    respond_to :js
end
