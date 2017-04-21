require 'mixpanel-ruby'

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
    invite_to_group(@user)
    mixpanel_account(@user)
  end

protected
  def after_sign_up_path_for(resource)
      email = resource.email
      invite = GroupInvite.find_by(email: email)
      if invite
        group = Group.find(invite.group_id)
        return "/groups/#{group.slug}#social-invite"
      else
        super
      end
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

  def mixpanel_account(user)
    mixpanel = Mixpanel::Tracker.new("2bce57b676bbaba5acae72984169bc49")
    mixpanel_params = {
       email: user.email,
       name: user.name,
       ip: user.current_sign_in_ip,
       first_name: user.first_name,
       last_name: user.last_name
     }
    mixpanel.people.set user.id, mixpanel_params
  end

private
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation)
  end
end
