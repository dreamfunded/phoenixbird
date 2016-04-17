class RegistrationsController < Devise::RegistrationsController


  def set_authority
    if params[:reg] == nil
      @authority = User.Authority[:Accredited]
    else
      @authority = User.Authority[:Basic]
    end
    ContactMailer.verify_email(record).deliver
    ContactMailer.account_created(record).deliver
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation, :authority)
  end
end
