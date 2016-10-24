class RegistrationsController < Devise::RegistrationsController

  def create
    super
    p "REGISTRATION CONTROLLER"
    if @user.persisted?
      @user.update_attribute(:authority, 2)
      ContactMailer.verify_email(@user).deliver
      ContactMailer.account_created(@user).deliver
    end
    check_if_was_invited(@user)
  end

protected

  def after_sign_up_path_for(resource)
    '/affiliate_code' # Or :prefix_to_your_route
  end
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def check_if_was_invited(user)
    email = user.email
    invited_person = user
    co_founder = CoFounder.find_by(email: email)
    supporter = Supporter.find_by(email: email)
    if co_founder
      co_founder.try(:user).try(:company).users << invited_person
      user.make_founder
    end
    if supporter
      supporter.try(:user).try(:company).users << invited_person
      user.make_supporter
    end
  end

private
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation)
  end
end
