require "spec_helper"

describe DataSetsController do
  describe "routing" do

    it "routes to #index" do
      get("/data_sets").should route_to("data_sets#index")
    end

    it "routes to #show" do
      get("/data_sets/1").should route_to("data_sets#show", :id => "1")
    end

  end
end
