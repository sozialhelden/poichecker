require 'spec_helper'

describe "Login Page", type: :controller do
  login_admin

  describe "GET /admin/login" do

    context "empty database" do

      before :each do
        visit '/admin/login'
      end

      it "renders successfull" do
        expect(page.status_code).to be(200)
      end

      it "displays title tag" do
        expect(page).to have_title 'Poichecker Login'
      end

      describe "content" do

        it "displays title headline" do
          expect(page).to have_selector 'h2', text: 'Poichecker Login'
        end

        it "displays a link" do
          expect(page).to have_selector 'a', text: 'Einloggen mit OpenStreetMap'
        end

      end
    end

    context "not logged in" do
      before :each do
        visit '/admin/places'
      end

      it "should redirect to login page" do
        expect(page.current_path).to eql "/admin/login"
      end
    end

    context "after login" do

      before :each do
        visit '/admin/login'
        click_link "Einloggen mit OpenStreetMap"
      end

      it "should redirect to places page" do
        expect(page.current_path).to eql "/admin/accounts/#{AdminUser.last.id}/edit_location"
      end
    end
  end
end