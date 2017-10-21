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
      render json: { errors: user.errors } , status: 422
    end
  end

  def update
    begin
      user = User.find(params[:id])
      
      if user.update(params_user)
        render json: user, status: 200
      else
        render json: { errors: user.errors } , status: 422
      end
    rescue => exception
      head 404
    end
    
  end

  def destroy
    begin
      user = User.find(params[:id])
      user.destroy
      head 204
    rescue => exception
      head 404
    end
  end

  protected 

    def params_user
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
