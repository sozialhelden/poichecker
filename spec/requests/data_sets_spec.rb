require 'spec_helper'

describe "DataSets" do
  describe "GET /data_sets" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get data_sets_path(locale: I18n.locale)
      response.status.should be(200)
    end
  end
end
