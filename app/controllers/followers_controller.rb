class FollowersController < UsersController
  before_action :verify_user!, only: [:index]

  def index
    @title = t :followers
    @users = @user.followers.paginate page: params[:page]
    render "show_follow"
  end
end
