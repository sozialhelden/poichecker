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

  def set_position
    login_admin

    before do
      VCR.configure do |c|
        c.cassette_library_dir = 'fixtures/nominatim'
        c.hook_into :webmock # or :fakeweb
      end
      visit '/admin/login'
      click_link "Einloggen mit OpenStreetMap"
      visit "/admin/places"
      # Should redirect user to edit locaton path
      VCR.use_cassette('unter_den_linden') do
        fill_in "Adresse", with: 'Unter den Linden 1, 10117 Berlin'
        click_button "festlegen"
      end
    end
  end
end