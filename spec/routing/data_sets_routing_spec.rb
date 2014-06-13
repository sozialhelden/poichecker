require "spec_helper"

describe DataSetsController do
  describe "routing" do

    it "routes to #index" do
      get("/de/data_sets").should route_to("data_sets#index", locale: "de")
    end

    it "routes to #show" do
      get("/de/data_sets/1").should route_to("data_sets#show", id: "1", locale: "de")
    end

  end
end
