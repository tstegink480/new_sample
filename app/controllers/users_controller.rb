class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def show
	  @user = User.find(params[:id])
          @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
      if signed_in?
        redirect_to(root_path)
      end
      @user = User.new
  end
  
  def create
  @user = User.new(params[:user])
  if signed_in?
      redirect_to(root_path)
  else if @user.save
      sign_in @user
      redirect_to @user
  else
      render 'new'
      end
  end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def edit
  end
  
    def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.admin?
        redirect_to(root_path)
    else
        User.find(params[:id]).destroy
        flash[:success] = "User destroyed."
        redirect_to users_url
    end
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
    
  
    private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
     def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    

end
