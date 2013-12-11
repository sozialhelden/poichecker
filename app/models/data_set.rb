class DataSet < ActiveRecord::Base

  validates :license, presence: true
end
