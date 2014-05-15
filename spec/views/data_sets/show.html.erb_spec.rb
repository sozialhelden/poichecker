require 'spec_helper'

describe "data_sets/show" do
  before(:each) do
    @data_set = assign(:data_set, FactoryGirl.create(:data_set))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
