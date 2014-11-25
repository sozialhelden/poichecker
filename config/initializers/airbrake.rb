if Rails.env.staging? || Rails.env.production?
  Airbrake.configure do |config|
    config.api_key = '17028af112f0ec1fce9071466a865e37'
  end
end