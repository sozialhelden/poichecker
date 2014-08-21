class Mapping < ActiveRecord::Base

  def self.import(csv_file)
    CSV.parse(csv_file, headers: true, encoding: 'UTF-8', header_converters: :string) do |row|
      Mapping.find_or_initialize_by(osm_key: row[:osm_key], osm_value: row[:osm_value], plural: row[:plural] ) do |mapping|
        mapping.locale = row[:locale]
        mapping.localized_name = row[:name]
        mapping.save!
      end
    end
  end

end
