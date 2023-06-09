class InvitesController < ApplicationController
  before_action :authenticate_user!
  require 'net/http'

  def invite
    @invites = Invite.where(user_id: current_user.id).where.not(email: nil).reverse
    @companies = Company.where(accredited: true)
    @members = Member.all
    @groups = Group.all
    @advisors = User.where(advisor: true)
  end

  def create
    @invite = Invite.create(invite_params)
    email = @invite.email
    name = @invite.name
    InviteMailer.invite_from_user(email, name, current_user).deliver
    flash[:email_sent] = "Email Sent"
    redirect_to '/invite'
  end


  def invite_from_startup
    @invite = Invite.create(invite_params)
    email = @invite.email
    name = @invite.name
    company_name = current_user.company.name
    ContactMailer.csv_invite(@invite, current_user.name, company_name).deliver
    flash[:email_sent] = "Email Sent"
    redirect_to '/invite'
  end


  def upload_csv
    begin
        @csv_file = CsvFile.new(csv_file_params)
        if @csv_file.save
          ContactMailer.file_uploaded(current_user).deliver
          flash[:email_sent] = "File has been uploaded, we will contact you after we have reviewed it."
          redirect_to  invite_users_path
        else
          #p @csv_file.errors
          flash[:upload_error] = "Invalid CSV file format."
          render :invite
        end
     rescue
        flash[:upload_error] = "Invalid CSV file format."
        redirect_to  invite_users_path
    end
  end

  def send_from_team_member
    @member = Member.find( params[:member] )
    flash[:email_sent] = "Emails sent from #{@member.name}"
    SubscribeJob.new.async.emails_from_member(params[:file], current_user, @member)
    redirect_to  invite_users_path
  end

  def invites_from_manny
    begin
        SubscribeJob.new.async.csv_save_emails(params[:file], current_user, 'from_Manny')
        flash[:email_sent] = "Emails sent"
        redirect_to  invite_users_path
      rescue
        flash[:upload_error] = "Invalid CSV file format."
        redirect_to  invite_users_path
    end
  end

  def send_csv_invites
    emails = params[:emails]
    names = params[:names]
    emails.each_with_index do |email, index|
      @invite = Invite.create(email: email,name: names[index], user_id: current_user.id)
      ContactMailer.delay.csv_invite(@invite, current_user)
    end
    redirect_to '/invite'
  end

  def view_uploaded_csv
    @invites = current_user.guests.reverse
  end

  def send_from_advisor
    @invite = Invite.create(name: params[:name], email: params[:email] )
    ContactMailer.send_from_advisor(@invite, current_user.name).deliver
    redirect_to '/invite'
  end

  def send_advisors_csv_invites
    begin
        @user = User.find(params[:advisor])
        SubscribeJob.new.async.csv_advisors_emails(params[:file], @user )
        flash[:email_sent] = "Emails sent from #{@user.name}"
        redirect_to  invite_users_path
      rescue
        flash[:upload_error] = "Invalid CSV file format."
        redirect_to  invite_users_path
    end
  end

  def invites_to_group
    begin
        @group = Group.find(params[:group])
        name = params[:name]
        SubscribeJob.new.async.csv_group_emails(params[:file], @group, name )
        flash[:email_sent] = "Emails sent from #{@group.name}"
        redirect_to  back
      rescue
        flash[:upload_error] = "Invalid CSV file format."
        redirect_to  :back
    end
  end

  def invites_to_real_estate
    begin
        SubscribeJob.new.async.invites_to_real_estate(params[:file] )
        flash[:email_sent] = "Emails sent"
        redirect_to  invite_users_path
      rescue
        flash[:upload_error] = "Invalid CSV file format."
        redirect_to  invite_users_path
    end
  end

  def invite_to_group
    @invite = GroupInvite.create(group_invite_params)
    @group = Group.find( @invite.group_id )
    InviteMailer.invite_to_group(@invite, current_user).deliver
    redirect_to @group
  end


  def download
    send_file(Rails.root.join('app' , 'assets', 'doc', "test_users.csv"))
  end

  def invite_cofounder
  end

  def post_invite_cofounder
    email = params[:email]
    name = params[:name]
    invited_person = User.find_by(email: email)

    if params[:role] == 'founder'
      CoFounder.create(email: email, name: name, user_id: current_user.id)
    elsif params[:role] == 'supporter'
      Supporter.create(email: email, name: name, user_id: current_user.id)
    end

    if invited_person
      current_user.company.users << invited_person
      invited_person.update(role: params[:role])
      ContactMailer.invite_cofounder_exist(email, name, current_user).deliver
    else
      ContactMailer.invite_cofounder_dont_exist(email, name, current_user).deliver
    end
    redirect_to company_path(current_user.company)
  end

  def send_start_up_emails
    name = params[:name]
    company = params[:company]
    file = params[:file]
    SubscribeJob.new.async.csv_send_checked_emails(file, name, company)
    redirect_to  invite_users_path
  end

  def group_invites
    session[:group_id] = params[:id]
     p session[:group_id]
  end
  #F R O M    S O C I A L   M E D I A
  def google_contacts
    id =  session[:group_id]
    group_id = Group.find_by(slug: session[:group_id] ).id
    emails = params[:emails]

    emails.each do |name_email|
      email = name_email.split(',').second
      name = name_email.split(',').first

      @invite = GroupInvite.create(email: email, name: name, group_id: group_id)
      InviteMailer.delay.invite_to_group(@invite, current_user)
      #@invite = Invite.create(email: email, user_id: current_user.id)
      #ContactMailer.delay.invite(@invite)
    end
    redirect_to "/group_invites/#{id}"
  end

  def google_contacts_on_campaign
    id =  session[:campaign_id]
    emails = params[:emails]

    emails.each do |name_email|
      email = name_email.split(',').second
      name = name_email.split(',').first

      @invite = Invite.create(email: email,name: name, user_id: current_user.id)
      InviteMailer.invite_from_user(email, name, current_user).deliver
    end
    redirect_to invite_contacts_path(id)
  end


  def accept
    @token = params[:token]
    @email = params[:email]
  end

  def accept_from_facebook
    user = User.find(params[:id])
    if user
      invite = Invite.create(user_id: user.id)
      @token = invite.token
    end
  end

  def create_from_social
    user = User.find(params[:id])
    if user
      @invite = Invite.create(user_id: user.id)
      redirect_to :action => 'accept', :token => @invite.token
    else
      redirect_to root_path
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:user_id, :email, :token, :name, :file, :group_id)
  end

  def group_invite_params
    params.require(:group_invite).permit(:user_id, :email, :token, :name, :file, :group_id)
  end

  def csv_file_params
    params.require(:csv_file).permit(:user_id, :file)
  end
end

