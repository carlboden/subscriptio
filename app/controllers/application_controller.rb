class ApplicationController < ActionController::Base
	add_flash_types :info, :success
    before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :function])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def after_sign_in_path_for(resource)
    if current_user.company_id != nil && ( current_user.status == "Approved" || current_user.company_admin)
      company_subscriptions_path(current_user.company_id)
    else
      user_path(current_user.id)
    end
  end
end
