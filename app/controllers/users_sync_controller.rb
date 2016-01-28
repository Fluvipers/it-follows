class UsersSyncController < ApplicationController
  skip_before_filter :check_user_is_authenticated!
  #after_save :set_encrypted_password

  def create
    @user = User.new(user_params)
    @user.password = '12345678'
    @user.password_confirmation = '12345678'
    if @user.save
      render json: {id: @user.id, user_token: @user.authentication_token, encrypted_password: @user.encrypted_password}
    else
      render json: @user.errors.to_json, status: :unprocessable_entity 
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    render json: {id: @user.id, user_token: @user.authentication_token, encrypted_password: @user.encrypted_password}
  end

  private

  def user_params
    params.require(:user).permit( :id, :email, :confirmed_at, :first_name, :last_name, :country, :role)
  end

  def set_encrypted_password
    @user.encrypted_password = user_params["encrypted_password"]
  end
end
