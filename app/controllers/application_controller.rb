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
    if params[:token]
      users = User.where(authentication_token: params[:token])
      users.one? ?  sign_in(:user, users.first) : authenticate_user!
    else
      authenticate_user!
    end
  end
end
