class UsersSyncController < ApplicationController
  skip_before_filter :check_user_is_authenticated!

  def create
    unless User.where(email: user_params[:email]).present?
      @user = User.new(user_params)
      @user.password = '12345678'
      @user.password_confirmation = '12345678'
      @user.confirmed_at = Time.now
      if @user.save
        set_encrypted_password(@user)
        render json: {id: @user.id, user_token: @user.authentication_token, encrypted_password: @user.encrypted_password}
      else
        render json: @user.errors.to_json, status: :unprocessable_entity
      end
    else
      update
    end
  end

  def update
    @user = params["id"].present? ? User.find_by_authentication_token(params[:id]) : User.find_by_authentication_token(params[:user]["email"])
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
