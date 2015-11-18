class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_lines

  private

  def set_lines
    @lines = Line.all
  end

  def set_new_routes
    Rails.application.routes.prepend { resources :proposals, except: [:destroy], as: 'line_entries', controller: 'line_entries' }
  end
end
