class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  acts_as_token_authentication_handler_for User, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :check_user_is_authenticated!
  before_action :set_lines
  respond_to :html, :json

  private

  def set_lines
    @lines = Line.all
  end

  def check_user_is_authenticated!
    params[:token].present? ? sign_in_user : authenticate_user!
  end

  def sign_in_user
    users.one? ?  sign_in(:user, users.first) : authenticate_user!
  end

  def users
    User.where(authentication_token: params[:token])
  end

end
