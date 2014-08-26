class Mapping < ActiveRecord::Base

  def self.import(csv_file)
    CSV.parse(csv_file, headers: true, encoding: 'UTF-8', header_converters: :string) do |row|
      attribs = {
        locale:         row[:locale],
        localized_name: row[:name],
        osm_key:        row[:osm_key],
        osm_value:      row[:osm_value],
        operator:       row[:operator],
        plural:         row[:plural]
      }

      Mapping.find_or_create_by(attribs)
    end
  end

end
