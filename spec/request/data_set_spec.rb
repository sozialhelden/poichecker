# encoding: UTF-8
require 'spec_helper'

describe "DataSets", type: :controller do
  login_admin

  describe "GET /admin/data_sets" do

    before :each do
      visit '/admin/login'
      click_link "Einloggen mit OpenStreetMap"
    end

    shared_examples "an empty page" do

      it "renders successfull" do
        expect(page.status_code).to be(200)
      end

      it "has not data sets." do
        expect(page).to have_text 'Es gibt noch keine Datensätze.'
      end

    end

    shared_examples "role independent" do

      it "renders successfull" do
        expect(page.status_code).to be(200)
      end

      it "has a name column" do
        expect(page).to have_selector '#index_table_data_sets thead th.col-name'
      end

      it "has a license column" do
        expect(page).to have_selector '#index_table_data_sets thead th.col-license'
      end

      it "has a place column" do
        expect(page).to have_selector '#index_table_data_sets thead th.col-orte'
      end

      it "has a name filter" do
        expect(page).to have_selector '.filter_form input#q_name'
      end

      it "has no batch action selector" do
        expect(page).not_to have_selector '.batch_actions_selector'
      end
    end

    shared_examples "admin specific" do
      it "has a create button" do
        expect(page).to have_selector '.action_items .action_item a', text: 'Datensatz erstellen'
      end

      it "has a link to admin resource" do
        expect(page).to have_selector 'ul.header-item #accounts a', text: 'Accounts'
      end

    end

    shared_examples "user specific" do
      it "does not have a create button" do
        expect(page).not_to have_selector '.action_items .action_item a', text: 'Datensatz erstellen'
      end

      it "has no license filter" do
        expect(page).not_to have_selector '.filter_form input#q_license'
      end

      it "has no description filter" do
        expect(page).not_to have_selector '.filter_form input#q_description'
      end

      it "has no created at filter" do
        expect(page).not_to have_selector '.filter_form input#q_created_at_gteq'
      end

      it "has no link to admin resource" do
        expect(page).not_to have_selector 'ul.header-item #admin_users a', text: 'Administratoren'
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
          visit '/admin/data_sets'
        end

        it_behaves_like "an empty page"
        it_behaves_like "admin specific"
      end

      context "with prepopulated database" do

        before :each do
          FactoryGirl.create(:data_set)
          visit '/admin/data_sets'
        end

        it_behaves_like "role independent"
        it_behaves_like "admin specific"

        it "has an id column" do
          expect(page).to have_selector '#index_table_data_sets thead th.col-id'
        end

        it "has a link to detail view" do
          expect(page).to have_selector 'a.view_link', text: 'Anzeigen'
        end

        it "has a link to edit view" do
          expect(page).to have_selector 'a.edit_link', text: 'Bearbeiten'
        end

        it "has a delete link" do
          expect(page).to have_selector 'a.delete_link', text: 'Löschen'
        end

        it "has a license filter" do
          expect(page).to have_selector '.filter_form input#q_license'
        end

        it "has a description filter" do
          expect(page).to have_selector '.filter_form input#q_description'
        end

        it "has a created at filter" do
          expect(page).to have_selector '.filter_form input#q_created_at_gteq'
        end

      end
    end

    context "as user" do

      context "with empty database" do

        before :each do
          visit '/admin/data_sets'
        end

        it_behaves_like "an empty page"
        it_behaves_like "user specific"
      end

      context "with prepopulated database" do

        before :each do
          FactoryGirl.create(:data_set)
          visit '/admin/data_sets'
        end

        it_behaves_like "role independent"
        it_behaves_like "user specific"

        it "has no id column" do
          expect(page).not_to have_selector '#index_table_data_sets thead th.col-id'
        end

        it "has no link to detail view" do
          expect(page).not_to have_selector 'a.view_link', text: 'Anzeigen'
        end

        it "has no link to edit view" do
          expect(page).not_to have_selector 'a.edit_link', text: 'Bearbeiten'
        end

        it "has no delete link" do
          expect(page).not_to have_selector 'a.delete_link', text: 'Löschen'
        end

      end
    end


  end

end