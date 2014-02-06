require 'spec_helper'

describe AdminUsers::OmniauthCallbacksController do

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
        'permissions' => ['allow_read_prefs', 'allow_write_api']
      }
    })
    request.env["devise.mapping"] = Devise.mappings[:admin_user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:osm]
  end

  after do
    OmniAuth.config.test_mode = false
  end

  shared_examples "any authorized user" do

    let :user do
      AdminUser.find_by_osm_id(174)
    end

    it "signs in the user" do
      get :osm
      controller.current_admin_user.should eql user
    end

    it "updates the users' oauth credentials" do
      get :osm
      user.reload
      user.oauth_token.should eql 'token'
      user.oauth_secret.should eql 'secret'
    end

  end

  context "known user" do

    before do
      FactoryGirl.create(:admin_user, :osm_id => 174)
    end

    it "does not create a new user" do
      lambda {
        get :osm
      }.should_not change(AdminUser, :count)
    end

   it_behaves_like "any authorized user"

  end

  context "new user" do

    it "does not create a new user" do
      lambda {
        get :osm
      }.should change(AdminUser, :count).by(1)
    end

    it_behaves_like "any authorized user"

  end

  shared_examples "any auth failure" do
    before do
      controller.should_not_receive(:find_or_create_user)
    end
    it "doesn't login user" do
      get :osm
      controller.current_admin_user.should be_nil
    end

  end

  context "missing permission allow_read_prefs" do
    before do
      OmniAuth.config.mock_auth[:osm]['info']['permissions'].delete('allow_read_prefs')
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:osm]
    end
    it_behaves_like "any auth failure"
  end

  context "missing permission allow_write_prefs" do
    before do
      OmniAuth.config.mock_auth[:osm]['info']['permissions'].delete('allow_write_api')
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:osm]
    end
    it_behaves_like "any auth failure"
  end

end