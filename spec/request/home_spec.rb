require 'spec_helper'

describe "Home Page" do

  describe "GET /" do

    context "empty database" do

      before :each do
        visit '/'
      end

      it "renders successfull" do
        expect(page.status_code).to be(200)
      end

      it "displays title tag" do
        expect(page).to have_title 'Poichecker Login'
      end

      describe "content" do

        it "displays message" do
          expect(page).to have_selector '.flash', text: 'Bitte melden Sie sich als Administrator an.'
        end

        it "displays a link" do
          expect(page).to have_selector 'a', text: 'Sign in with OpenStreetMap'
        end

      end


    end
  end
end