Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :gplus,    ENV['GOOGLE_KEY'],   ENV['GOOGLE_SECRET']
  provider :identity, :fields => [:email]
end

OmniAuth.config.logger = Rails.logger
