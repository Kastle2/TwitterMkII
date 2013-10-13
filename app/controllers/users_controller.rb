class UsersController < ApplicationController
# so each controller (associated with a model and view) can have:
# create (make new instance)->  CREATE
# index: show all/ page of all model instances: eg: all users 
#  -> READ
# update (edit exsiting instance's fields) -> UPDATE
# delete (delete an instance) -> DELETE

  before_action :signed_in_user, only: [:edit, :update, :index]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    # was; pre-pagination
    # @users = User.all
    #  now: allows pagination:
    @users = User.paginate(page: params[:page])
  end

	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
	end

  def edit
    # @user = User.find(params[:id])
  end

  def create
    # old version:
    # @user = User.new(params[:user])    # Not the final implementation!
    # new version:
    @user = User.new(user_params)
    if @user.save
      sign_in @user #Signing in the user upon signup
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
     render 'new'
   end
 end

 def update
  # @user = User.find(params[:id])
  if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private
  def user_params
   params.require(:user).permit(:name, :email, :password,
    :password_confirmation)
  end

  # Before filters

  #  moved to SessionsHelper
  # def signed_in_user
  #   store_location
  #   redirect_to signin_url, notice: "Please sign in." unless signed_in?
  # end

  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
      redirect_to(root_url) unless current_user.admin?
  end

end