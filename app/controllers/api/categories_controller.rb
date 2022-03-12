class Api::CategoriesController < ApplicationController
  before_action :check_token
  before_action :find_category, only: [:show, :update, :destroy]

  def index
    categories = Category.where(user_id: @current_user.id )
    render json: { data:  categories, message: "Successfully get all categories by user", status: 'Success' }, include: [ { user: { except: :authentication_token} }, :tasks]
  end

  def show
    render json: { data: @category, message: "Successfully get specific category", status: 'Success' }, include: [ { user: { except: :authentication_token} }, :tasks]
  end

  def create
    category = Category.new({
      name: params[:name],
      description: params[:description],
      user_id: @current_user.id
    })
    if category.save
      render json:{ data: category, status: "Successfully Created Category"}, status: :ok
    else
      render json: { errors: category.errors.full_messages, status: "Error" }
    end
  end

  def update
    if @category.update({
      name: params[:name],
      description: params[:description],
    })
    render json:{ data: @category, status: "Successfully Created Category"}, status: :ok
    else
      render json: { errors: @category.errors.full_messages, status: "Error", message: "Error update" }
    end
  end

  def destroy
    if @category.destroy
    render json:{ message: "Successfully Deleted Category", status: "Success" }, status: :ok
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

  def find_category
    @category = Category.find_by(user_id: @current_user.id, id: params[:id] )
    return if @category

    render json: { message: 'Category id not found.', status: "Error"}
  end
end