class FollowingController < UsersController
  before_action :verify_user!, only: [:index]

  def index
    @title = t :following
    @users = @user.following.paginate page: params[:page]
    render "show_follow"
  end

end
