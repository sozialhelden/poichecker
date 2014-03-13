# encoding: UTF-8
require 'spec_helper'

describe "Home Page", type: :controller do
  login_admin

  describe "GET /dashboard" do

    before :each do
      visit '/admin/login'
      click_link "Einloggen mit OpenStreetMap"
    end

    context "empty database" do

      before :each do
        visit '/admin/dashboard'
      end

      it "renders successfull" do
        expect(page.status_code).to be(200)
      end

      it "displays title tag" do
        expect(page).to have_title 'Übersicht | Poichecker'
      end

      it "displays title headline" do
        expect(page).to have_selector 'h2', text: 'Übersicht'
      end

      describe "welcome box" do

        it "displays headline" do
          expect(page).to have_selector '#welcome span', text: 'Willkommen bei Poichecker'
        end

        it "has a field for email" do
          expect(page).to have_selector '#welcome input#account_email'
        end

      end


    end

    context "prepolated database" do

      let :user do
        AdminUser.find_by_osm_id(174)
      end

      let! :place do
        FactoryGirl.create(:place, name: "Neptunbrunnen")
      end

      let! :comment do
        FactoryGirl.create(:comment, resource: place, author: user)
      end

      before :each do
        user.update_attribute(:email, 'admin@example.com')
        visit '/admin/dashboard'
      end

      it "has no welcome box" do
        expect(page).not_to have_selector '#welcome'
      end

      it "has a comment box with comments" do
        expect(page).to have_selector '#comments .active_admin_comment'
      end

    end
  end
end