class Api::V1::UsersController < ApplicationController
  respond_to :json

  def show
    begin
      user = User.find(params[:id])
      respond_with user
    rescue => exception
      head 404
    end
  end

  def create
    user = User.new(params_user)

    if user.save
      render json: user, status: 201
    else
      
    end
  end

  protected 

    def params_user
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
