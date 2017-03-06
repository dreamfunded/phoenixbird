class UserVerification
  def initialize(user)
    @user = user
    @identities_by_provider = @user.identities.index_by {|identity| identity.provider}
  end

  def email
    @user.confirmed?
  end

  def phone
    false
  end

  def facebook
    @identities_by_provider['facebook']
  end

  def google
    @identities_by_provider['google_oauth2']
  end

  def linkedin
    @identities_by_provider['linkedin']
  end

  def twitter
    nil
  end

  def angellist
    nil
  end

  def to_json
    {
      user: {
        email: email,
        phone: phone
      },
      connected_accounts: {
        facebook: facebook.present?,
        google: google.present?,
        linkedin: linkedin.present?,
        twitter: twitter.present?,
        angellist: angellist.present?
      }
    }
  end
end