require 'csv'
class CSV
  class StringConverter
    HeaderConverters[:string] = lambda do |h|
      h.encode(ConverterEncoding).parameterize.underscore.to_sym
    end
  end
end