class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_to do |format|
        format.html { respond_with resource, location: after_sign_in_path_for(resource)}
        format.json { render json: {email: current_user.email, token: current_user.authentication_token}}
    end
  end
end
