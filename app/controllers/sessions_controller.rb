class SessionsController < ApplicationController

  def create
    @user = User.from_omniauth(env['omniauth.auth'])
    session[:user_id] = @user.id
    redirect_to parties_path
    flash[:notice] = "You are signed in as #{@user.name}"
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_url, notice: "Signed out!"
  end
end
