require 'spec_helper'

describe "DataSets", type: :controller do
  login_admin

  describe "GET /data_sets" do

    before :each do
      visit '/'
      click_link "Sign in with OpenStreetMap"
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
    end

    shared_examples "admin specific" do
      it "has a create button" do
        expect(page).to have_selector '.action_items .action_item a', text: 'Datensatz erstellen'
      end
    end

    shared_examples "user specific" do
      it "does not have a create button" do
        expect(page).not_to have_selector '.action_items .action_item a', text: 'Datensatz erstellen'
      end
    end

    context "as admin" do

      before :each do
        AdminUser.find_by_osm_id(174).update_attribute(:role, 'admin')
      end

      context "with empty database" do

        before :each do
          visit '/data_sets'
        end

        it_behaves_like "an empty page"
        it_behaves_like "admin specific"
      end

      context "with prepopulated database" do

        before :each do
          FactoryGirl.create(:data_set)
          visit '/data_sets'
        end

        it_behaves_like "role independent"
        it_behaves_like "admin specific"

        it "has an id column" do
          expect(page).to have_selector '#index_table_data_sets thead th.col-id'
        end

        it "has a create a button" do
          expect(page).to have_selector '.action_items .action_item a', text: 'Datensatz erstellen'
        end

      end
    end

    context "as user" do

      context "with empty database" do

        before :each do
          visit '/data_sets'
        end

        it_behaves_like "an empty page"
        it_behaves_like "user specific"
      end

      context "with prepopulated database" do

        before :each do
          FactoryGirl.create(:data_set)
          visit '/data_sets'
        end

        it_behaves_like "role independent"
        it_behaves_like "user specific"

        it "has no id column" do
          expect(page).not_to have_selector '#index_table_data_sets thead th.col-id'
        end

      end
    end


  end

end