require 'spec_helper'

describe "Login Page" do

  describe "GET /admin_users/login" do

    context "empty database" do

      before :each do
        visit '/admin_users/login'
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
  end
end