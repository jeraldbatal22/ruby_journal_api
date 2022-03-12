class Api::SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])

    if !user
      render json: { message: 'User does not exist', status: "Error"} , status: :ok
      return true
    end

    if user.valid_password?(params[:password])
      user.save
      render json:{ data: user.as_json(only: [:email, :id, :username, :firstname, :lastname, :authentication_token]), status: "Successfully Login"}, status: :ok
     else
      render json: { message: 'Invalid email or password', status: "Error"} , status: :unauthorized
     end
  end
end