class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  acts_as_token_authentication_handler_for User 
  before_action :set_lines

  private

  def set_lines
    @lines = Line.all
  end
end
