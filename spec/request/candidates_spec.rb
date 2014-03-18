# encoding: UTF-8
require 'spec_helper'

describe "Candidates", type: :controller do
  login_admin

  describe "GET /admin/candidates/:id" do

    before :each do
      VCR.configure do |c|
        c.cassette_library_dir = 'fixtures/overpass'
        c.hook_into :webmock # or :fakeweb
      end
      visit '/admin/login'
      click_link "Einloggen mit OpenStreetMap"
    end

    context "as user" do

      context "with prepopulated database" do

        let! :place do
          FactoryGirl.create(:place)
        end

        before :each do
          place
          VCR.use_cassette('a_node') do
            visit "/admin/places/#{place.id}/candidates/333537503?osm_type=node"
          end

        end

        it "renders successfull" do
          expect(page.status_code).to be(200)
        end
      end
    end
  end
end