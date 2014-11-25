Airbrake.configure do |config|
  config.api_key = '17028af112f0ec1fce9071466a865e37'

  config.ignore << "Rosemary::Gone"
  config.ignore << "Rosemary::ServerError"
  config.ignore << "Rosemary::Unavailable"
end
