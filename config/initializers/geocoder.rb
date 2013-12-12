Geocoder.configure(
  # geocoding options
  :timeout      => 60,           # geocoding service timeout (secs)
  :lookup       => :nominatim,     # name of geocoding service (symbol)
  :language     => :de,         # ISO-639 language code
  # :use_https    => false,       # use HTTPS for lookup requests? (if supported)
  # :http_proxy   => nil,         # HTTP proxy server (user:pass@host:port)
  # :https_proxy  => nil,         # HTTPS proxy server (user:pass@host:port)
  # :api_key      => nil,         # API key for geocoding service
  # :cache        => nil,         # cache object (must respond to #[], #[]=, and #keys)
  # :cache_prefix => "geocoder:", # prefix (string) to use for all cache keys
  # :units => :km,                # set default units to kilometers


  # exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and TimeoutError
  # :always_raise => [],

  # calculation options
  # :units     => :mi,       # :km for kilometers or :mi for miles
  # :distances => :linear    # :spherical or :linear

  # header information
  :http_headers => { "User-Agent" => "Wheelmap v1.0, (http://wheelmap.org)" }
)
