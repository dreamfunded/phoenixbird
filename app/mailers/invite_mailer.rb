class InviteMailer < ActionMailer::Base
  default from: "DreamFunded <info@dreamfunded.com>"

  def invite(invite)
    @email = invite.email
    @name = invite.user.name
    @token = invite.token
    mail(to: @email, subject: "Congratulations, #{@name} has given you $100 to invest on DreamFunded")
  end

  def invite_from_user(email, name, user)
    @email = email
    @name = name
    @user = user
    mail(to: @email, subject: "Hi #{@name}, your friend #{@user.name} has invited you to join DreamFunded" )
  end

  def invite_to_sign_up(email, name)
    mail(to: email, subject: "#{name.try(:capitalize)}, please accept my invite to DreamFunded")
  end

  def csv_invite(invite, user_name, user_company)
    @invite = invite
    @user_name = user_name
    @user_company = user_company
    mail(to: @invite.email, subject: "Hi #{@invite.try(:name).try(:capitalize)}, it's #{@user_name}. Check out my startup on DreamFunded.")
  end

  def invite_cofounder_exist(email, name, current_user)
    @email = email
    @name = name
    @current_user = current_user
    @company = current_user.company
    mail(to: email, subject: "#{@current_user.name} has invited you to collaborate on #{@company.name} ")
  end

  def invite_cofounder_dont_exist(email, name, current_user)
    @email = email
    @name = name
    @current_user = current_user
    @company = current_user.company
    mail(to: email, subject: "#{@current_user.name} has invited you to collaborate on #{@company.name} ")
  end

  def file_uploaded(user)
    @user = user
    mail(to: "manny@dreamfunded.com", subject: "#{@user.name} uploaded CSV file")
  end

  def invite_from_member(email, name, member)
    @email = email
    @name = name
    @member = member
    mail(to: email, subject: "Hi #{@name}, your friend #{@member.name} has invited you to join DreamFunded" )
  end

  def send_from_advisor(invite, advisor)
    @advisor = advisor
    @email = invite.email
    @name = invite.name
    mail(to: @email, subject: "Hi #{@name}, your friend #{@advisor.name} has invited you to join DreamFunded" )
  end

  def invite_to_group(invite, user)
    @invite, @user = invite, user
    @group = Group.find(@invite.group_id)
    mail(to: @invite.email, subject: "Hi #{@invite.name}, your friend #{@user.name} has invited you to join #{@group.name} group on DreamFunded" )
  end

  def invite_to_group_from_csv(invite, name)
    @invite, @name = invite, name
    @group = Group.find(@invite.group_id)
    mail(to: @invite.email, subject: "Hi #{@invite.name}, your friend #{@name} has invited you to join #{@group.name} group." )
  end

  def new_group_post(group, user)
    @group, @user = group, user
    mail(to: @user.email, subject: "Hi #{@user.name}, new blog post in your #{group.name} Group " )
  end

  def invites_to_real_estate(invite)
    @invite = invite
    mail(to: @invite.email, subject: "Hi #{@invite.name}, you are invited to invest in Real Estate." )
  end

end

