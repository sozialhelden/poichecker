# == Schema Information
#
# Table name: mappings
#
#  id             :integer          not null, primary key
#  locale         :string(255)      not null
#  localized_name :string(255)      not null
#  osm_key        :string(255)
#  osm_value      :string(255)
#  plural         :boolean
#  operator       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Mapping do
  pending "add some examples to (or delete) #{__FILE__}"
end
