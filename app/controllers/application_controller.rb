class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      [:sign_up, :account_update].each do |devise_action|
        devise_parameter_sanitizer.permit(devise_action, keys: [:name])
      end
    end
end
