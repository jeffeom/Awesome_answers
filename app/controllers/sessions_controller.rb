class SessionsController < ApplicationController
  def new
  end

  def create
    # we attempt to find the user by their email. The find_by_email method
    # will return at most one record with the given email. If no user with
    # the given email exists, then we get back nil.
    user = User.find_by_email params[:email]
    # We first check that the usesr exists, because it could be nil if the user
    # entered a wrong email. Then we use the 'authenticate' method which came
    # from 'has_secure_password' which will give us false if the password is
    # wrong and will return the user if the password is correct.
    if user && user.authenticate(params[:password])
      # we use session in order to keep the user logged in. Session in Rails
      # are encrypted by defaulted using a secret_key that can be found inside
      # config/secrets.yml
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged In!"
    else
      flash[:alert] = "Wrong Credentials!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged Out!"
  end
end
