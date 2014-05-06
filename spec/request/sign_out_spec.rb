# encoding: UTF-8
require 'spec_helper'

describe "Signout Page", type: :controller do
  set_position

  describe "GET /admin/places" do

    before :each do
      visit '/admin/places'
    end

    it "renders successfull" do
      expect(page.status_code).to be(200)
    end

    it "should send me to start page after sign out" do
      click_link "Abmelden"
      expect(page.current_path).to eql "/"
    end
  end
end