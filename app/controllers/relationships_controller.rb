class RelationshipsController < ApplicationController
  before_action :signed_in_user

  # was: (non-ajax):
  # def create
  #   @user = User.find(params[:relationship][:followed_id])
  #   current_user.follow!(@user)
  #   redirect_to @user
  # end

  # def destroy
  #   @user = Relationship.find(params[:id]).followed
  #   current_user.unfollow!(@user)
  #   redirect_to @user
  # end

  # now: with ajax:

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
end