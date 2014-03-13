class DataSetsController < InheritedResources::Base

  actions :index, :show

  respond_to :html
end
