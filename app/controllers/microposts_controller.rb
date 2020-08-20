class MicropostsController < ApplicationController
  before_action :logged_in_user,only:  %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t ".create_success"
      redirect_to root_url
    else
      @feed_items = feed_item
      flash.now[:danger] = t ".create_faild"
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:danger] = t ".delete_faild"
    end
    redirect_to request.referer || root_url
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t ".can_not_find_micropot"
    redirect_to root_url
  end

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def feed_item
    current_user.feed.page(params[:page]).per Settings.paginate.items_per_page
  end
end
