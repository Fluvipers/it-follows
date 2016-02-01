class UsersSyncController < ApplicationController
  skip_before_filter :check_user_is_authenticated!

  def create
    @user = User.new(user_params)
    @user.password = '12345678'
    @user.password_confirmation = '12345678'
    if @user.save
      set_encrypted_password(@user)
      render json: {id: @user.id, user_token: @user.authentication_token, encrypted_password: @user.encrypted_password}
    else
      render json: @user.errors.to_json, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by_authentication_token(params[:id])
    @user.update(user_params)
    render json: {id: @user.id, user_token: @user.authentication_token, encrypted_password: @user.encrypted_password}
  end

  private

  def user_params
    params.require(:user).permit( :id, :email, :confirmed_at, :first_name, :last_name, :country, :role, :encrypted_password)
  end

  def set_encrypted_password(user)
    user.encrypted_password = user_params["encrypted_password"]
    user.save
  end
end
