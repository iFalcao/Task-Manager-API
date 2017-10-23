class Api::V1::SessionsController < ApplicationController

  def create
    user = User.find_by(email: params_session[:email])

    if user && user.valid_password?(params_session[:password])
      render json: user, status: 200
    end
  end

  def destroy
    
  end

  protected

    def params_session
      params.require(:session).permit(:email, :password)
    end

end
