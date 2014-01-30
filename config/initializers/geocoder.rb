require 'ostruct'
require 'yaml'
geocoder_config = YAML.load_file(Rails.root.join('config', 'geocoder.yml'))
GeocoderConfig = OpenStruct.new geocoder_config[Rails.env]

Geocoder.configure(
  # geocoding options
  # :timeout      => 5,           # geocoding service timeout (secs)
  :lookup       => :nominatim,    # name of geocoding service (symbol)
  :language     => :de,           # ISO-639 language code
  # :use_https    => false,       # use HTTPS for lookup requests? (if supported)
  # :http_proxy   => nil,         # HTTP proxy server (user:pass@host:port)
  # :https_proxy  => nil,         # HTTPS proxy server (user:pass@host:port)
  # :api_key      => nil,         # API key for geocoding service
  # :cache        => nil,         # cache object (must respond to #[], #[]=, and #keys)
  # :cache_prefix => "geocoder:", # prefix (string) to use for all cache keys
  :units => :km,                  # set default units to kilometers

  # You can also configure multiple geocoding services at once, like this:
  :nominatim => {
     :timeout => 60
   },

   :here => {
     :api_key => [GeocoderConfig.here["app_id"], GeocoderConfig.here["app_code"]],
     :timeout => 5
   },

  # exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and TimeoutError
  # :always_raise => [],

  # calculation options
  # :units     => :mi,       # :km for kilometers or :mi for miles
  # :distances => :linear    # :spherical or :linear

  # header information
  :http_headers => { "User-Agent" => "Poichecker v1.0, (http://poichecker.de)", "email" => "christoph@sozialhelden.de" }
)
