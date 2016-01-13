class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  acts_as_token_authentication_handler_for User 
  before_action :authenticate_user!
  before_action :set_lines
  respond_to :html, :json

  private

  def set_lines
    @lines = Line.all
  end
end
