class Api::TasksController < ApplicationController
  # before_action :check_token
  before_action :check_token
  before_action :find_task,  only: [:show, :update, :destroy]
  before_action :find_category, only: [:create, :update, :destroy]

  def index
    task = Task.where(user_id: @current_user.id, category_id: params[:category_id])
    render json: { data: task, message: "Successfully get all task by user", status: 'Success' }
  end

  def show
    render json: { data: @task, message: "Successfully get specific task", status: 'Success' }
  end

  def create
    task = Task.new({
      name: params[:name],
      description: params[:description],
      user_id: @current_user.id,
      category_id: params[:category_id]
    })
    if task.save
      render json:{ data: task, status: "Successfully Created task"}, status: :ok
    else
      render json: { errors: task.errors.full_messages, status: "Error" }
    end
  end

  def update
    if @task.update({
      name: params[:name],
      description: params[:description],
      user_id: @current_user.id,
      category_id: params[:category_id]
    })

    render json:{ data: @task, status: "Successfully Updated task"}, status: :ok
    else
      render json: { errors: @task.errors.full_messages, status: "Error", message: "Error update task" }
    end
  end

  def destroy
    if @task.destroy
    render json:{ message: "Successfully Deleted task", status: "Success" }, status: :ok
    else
      render json: { errors: "Error delete", status: "Error" }
    end
  end

  private

  def check_token
    pattern = /^Bearer /
    header  = request.headers['Authorization']
    if header
      tokenKey = header.split(' ').first
      token = header.split(' ').last
      if tokenKey == 'Bearer'
        user = User.find_by_authentication_token(token)
        @current_user = user
        if !user 
            render json: {
            message: 'Login first',
            status: 'Not Login'
          } 
        end
      else 
        render json: {
          message: 'Invalid Bearer',
          status: 'Error'
        }
      end
    else 
      render json: {
          message: 'Required Token Bearer',
          status: 'Error'
        }
    end
  end

  def find_task
    @task = Task.find_by(user_id: @current_user.id, id: params[:id], category_id: params[:category_id] )
    return if @task

    render json: { message: 'Task id not found.', status: "Error"}
  end

  def find_category
    @find_category = Category.find_by(id: params[:category_id], user_id: @current_user.id)
    return if @find_category
    render json: { message: "Category Id Not Found", status: "Error" }
  end
end