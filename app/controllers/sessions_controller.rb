class SessionsController < ApplicationController
  def new
  end

  def create
    #  this line works with "form_for" in new.html.erb
  	 # user = User.find_by(email: params[:session][:email].downcase)
    
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end

  end

  def destroy
    sign_out
    redirect_to root_url
  end
end