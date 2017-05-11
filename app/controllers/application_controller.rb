class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    helper_method :authority
    before_action :logout_user_session

    # def user_session
    # 	session[:current_user]
    # end

    def authority
    	User.Authority
    end

    def logout_user_session
      session[:current_user] = nil
    end

    def set_admin_timezone
      Time.zone = "Pacific Time (US & Canada)"
    end

    def configure_permitted_parameters
       devise_parameter_sanitizer.for(:account_update) { |u|
         u.permit(:password, :password_confirmation, :current_password)
       }
    end
end
