class RegistrationsController < Devise::RegistrationsController

  def create
    super
    p "REGISTRATION CONTROLLER"
    if @user.persisted?
      @user.update_attribute(:authority, 2)
      ContactMailer.delay.verify_email(@user)
      ContactMailer.delay.account_created(@user)
    end
    check_if_was_invited(@user)
    invite_to_group(@user)
  end

protected
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

  def invite_to_group(user)
    p 'Inviting to Group'
    email = user.email
    invite = GroupInvite.find_by(email: email)
    p email
    p invite
    if invite
      group = Group.find(invite.group_id)
      user.groups << group
    end
  end

private
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation)
  end
end
