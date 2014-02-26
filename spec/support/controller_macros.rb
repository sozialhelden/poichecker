module ControllerMacros
  def login_admin
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:osm, {
        'provider' => 'osm',
        'uid' => '174',
        'credentials' => {
          'token' => 'token',
          'secret' => 'secret'
        },
        'info' => {
          'display_name' => 'a_funky_osm_name',
          'id' => '174',
          'lat' => '52.510911896456',
          'lon' => '13.393013381407',
          'permissions' => ['allow_read_prefs', 'allow_write_api']
        }
      })

      request.env["devise.mapping"] = Devise.mappings[:admin_user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:osm]
    end

    after do
      OmniAuth.config.test_mode = false
    end
  end
end