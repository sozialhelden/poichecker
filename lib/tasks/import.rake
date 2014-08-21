namespace :import do

  desc 'Import places'
  task :places => :environment do
    csv_file = ENV['FILE'] or raise "Usage: bundle exec rake import:places FILE=CSV_FILE DATASET=\"HypoVereinsbank\""
    data_set_name = ENV['DATASET'] or raise "Usage: bundle exec rake import:places FILE=CSV_FILE DATASET=\"HypoVereinsbank\""
    data_set = DataSet.find_by_name(data_set_name)
#    raise File.new(csv_file).inspect
    Place.import(File.new(csv_file), data_set)
  end

  desc 'Import mappings'
  task :mappings => :environment do
    csv_file = ENV['FILE'] or raise "Usage: bundle exec rake import:mappings FILE=CSV_FILE"
    Mapping.import(File.new(csv_file))
  end

end