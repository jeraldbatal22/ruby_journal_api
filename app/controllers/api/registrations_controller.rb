class Api::RegistrationsController < ApplicationController
  def create
    user = User.new({
      email: params[:email],
      username: params[:username],
      firstname: params[:firstname],
      lastname: params[:lastname],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    })
    
    if user.save
      render json:{ data: user.as_json(only: [:email, :id, :username, :firstname, :lastname]), status: "Successfully Register Account"}, status: :ok
    else
      render json: { errors: user.errors.full_messages, status: "Error" }
    end
  end
end