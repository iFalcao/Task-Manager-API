class Api::V2::TasksController < ApplicationController
  before_action :authenticate_with_token!

  def index
    tasks = current_user.tasks
    render json: tasks, status: 200
  end

  def show
    begin
      task = current_user.tasks.find(params[:id])
      render json: task, status: 200
    rescue => exception
      head 404
    end
  end

  def create
    task = current_user.tasks.build params_task

    if task.save
      render json: task, status: 201
    else
      render json: { errors: task.errors }, status: 422
    end
  end

  def update
    task = current_user.tasks.find(params[:id])

    if task.update params_task
      render json: task, status: 200
    else
      render json: { errors: task.errors }, status: 422
    end
  end

  def destroy
    task = current_user.tasks.find(params[:id])
    task.destroy
    head 204
  end

  protected

    def params_task
      params.require(:task).permit(:title, :description, :done, :deadline)
    end
end