require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, '53258587093-kl5m6bi61j835409ncebrhr9dtvmt0se.apps.googleusercontent.com', 'zuN6_MdtvUkOlqKfyL9sL6tF', {:redirect_path => "/oauth2callback", :ssl_ca_file => "/etc/ssl/certs/curl-ca-bundle.crt"}
  importer :yahoo,  "dj0yJmk9ckFsZFpxWWxoR0ozJmQ9WVdrOVRuTkhZWEJpTjJjbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD0zOA--", "df659f0d4518fc67e807533da97355ad504a8cf8", {:callback_path => "/contacts_callback"}
  #importer :linkedin, "consumer_id", "consumer_secret", {:redirect_path => "/oauth2callback", :state => '<long_unique_string_value>'}
  #importer :hotmail, "client_id", "client_secret"
  #importer :outlook, "app_id", "app_secret"
  #importer :facebook, "client_id", "client_secret"
end
