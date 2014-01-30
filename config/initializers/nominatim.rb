Nominatim.configure do |config|
  config.endpoint = 'http://open.mapquestapi.com/nominatim/v1'
  config.accept_language = 'de'
  config.email = 'christoph@sozialhelden.de'
  config.user_agent = 'Poichecker v1.0, (http://poichecker.de)'
end