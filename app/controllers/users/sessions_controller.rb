class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

# GET /resource/sign_in
# def new
#   super
# end

# POST /resource/sign_in
  def create
    # super
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    current_user.update_attribute(:private_token, "#{SecureRandom.uuid.gsub('-', '')}")
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

# DELETE /resource/sign_out
  def destroy
    current_user.update_attributes(private_token: nil)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    respond_to_on_destroy
  end

# protected

# If you have extra params to permit, append them to the sanitizer.
# def configure_sign_in_params
#   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
# end
end
