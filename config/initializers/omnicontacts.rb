require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, '53258587093-kl5m6bi61j835409ncebrhr9dtvmt0se.apps.googleusercontent.com', 'zuN6_MdtvUkOlqKfyL9sL6tF', {:redirect_path => "/oauth2callback", :ssl_ca_file => "/etc/ssl/certs/curl-ca-bundle.crt"}
  importer :yahoo,  "dj0yJmk9cUFpbmk5Y2ZyQTZUJmQ9WVdrOVdrdFBWRkJOTkdzbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD01ZA--", "42bc1be2baff80b58eb1b3a70f27431cbc2c2543", {:callback_path => "/contacts_callback"}
  #importer :linkedin, "consumer_id", "consumer_secret", {:redirect_path => "/oauth2callback", :state => '<long_unique_string_value>'}
  #importer :hotmail, "client_id", "client_secret"
  #importer :outlook, "app_id", "app_secret"
  #importer :facebook, "client_id", "client_secret"
end
