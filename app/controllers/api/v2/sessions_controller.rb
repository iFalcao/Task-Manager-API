class Api::V2::SessionsController < ApplicationController

  def create
    user = User.find_by(email: params_session[:email])

    if user && user.valid_password?(params_session[:password])
      # 'Sign in' is a Devise Helper to record login info to database
      # and store: false is to not store the session since the API is stateless
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200
    else
      render json: { errors: 'Invalid password or e-mail' }, status: 401
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token!
    user.save
    head 204
  end

  protected

    def params_session
      params.require(:session).permit(:email, :password)
    end

end
