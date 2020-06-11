class OmniauthCallbacksController < ApplicationController
  before_action :cors_set_access_control_headers

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      p "I AM HERE 1"
      sign_in_and_redirect @user
    else
      p "I AM HERE 2"
      session["devise.user_attributes"] = @user.attributes
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    p request.env["omniauth.auth"]
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      ContactMailer.account_created(@user).deliver
      sign_in_and_redirect @user, notice:'Signed In'
    else
      session["devise.user_attributes"] = @user.attributes
      flash[:signup_errors] = @user.errors.full_messages.first
      redirect_to new_user_registration_url
    end
  end
  alias_method :google, :google_oauth2

  def omniauth_failure
    p '$$$$$$$$$$$$$$$$$$$$$$$$$$$'
    p params

    flash[:signup_errors] = params.first.try(:last)

    redirect_to new_user_registration_path
    #redirect wherever you want.
  end

  def contacts_callback
    @contacts = request.env['omnicontacts.contacts']
    p @contacts
    @user = request.env['omnicontacts.user']

    puts "List of contacts of #{@user[:name]} obtained from #{params[:importer]}:"
    @hash = {}

    @contacts.each do |contact|

        @hash[contact[:name]] = contact[:email]

        puts "Contact found: name => #{contact[:name]}, email => #{contact[:email]}"

    end
    render "import/authorise"
  end

  private

  def cors_set_access_control_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email'
    response.headers['Access-Control-Max-Age'] = "1728000"
  end

end
