# encoding: UTF-8
require 'spec_helper'

describe "Place", type: :controller do
  login_admin

  describe "GET /admin/places" do

    before :each do
      visit '/admin/login'
      click_link "Einloggen mit OpenStreetMap"
    end

    shared_examples "an empty page" do

      it "renders successfull" do
        expect(page.status_code).to be(200)
      end

      it "has no places." do
        expect(page).to have_text 'Es gibt noch keine Orte.'
      end
    end

    shared_examples "role independent" do

      it "renders successfull" do
        expect(page.status_code).to be(200)
      end

      it "has a name column" do
        expect(page).to have_selector '#index_table_places thead th.col-name'
      end

      it "has a address column" do
        expect(page).to have_selector '#index_table_places thead th.col-address'
      end

    end

    shared_examples "admin specific" do

      it "has a data_set filter" do
        expect(page).to have_selector '.filter_form select#q_data_set_id'
      end

      it "has a name filter" do
        expect(page).to have_selector '.filter_form input#q_name'
      end

    end

    context "as admin" do

      let :role do
        FactoryGirl.create(:admin_role)
      end

      let :user do
        AdminUser.find_by_osm_id(174)
      end

      before :each do
        user.update_attribute(:role, role)
        expect(user).to be_admin
      end

      context "with empty database" do

        before :each do
          visit '/admin/places'
        end

        it_behaves_like "an empty page"
        it_behaves_like "admin specific"
      end

      context "with prepopulated database" do

        before :each do
          FactoryGirl.create(:place)
          visit '/admin/places'
        end

        it_behaves_like "role independent"
        it_behaves_like "admin specific"

      end
    end
  end
end