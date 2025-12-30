Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_SECRET_KEY']
  on_failure do |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  end
end