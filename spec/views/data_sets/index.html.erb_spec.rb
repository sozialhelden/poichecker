require 'spec_helper'

describe "data_sets/index" do
  before(:each) do
    assign(:data_sets, [
      stub_model(DataSet),
      stub_model(DataSet)
    ])
  end

  it "renders a list of data_sets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
