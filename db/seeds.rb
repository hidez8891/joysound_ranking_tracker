Artist.delete_all
Song.delete_all
Log.delete_all

[Artist, Song, Log].each do |c|
  yml_path = "#{Rails.root}/db/seeds/#{c.to_s.tableize}.yml"
  next unless File.exists?(yml_path)

  YAML.load_file(yml_path).each do |r|
    c.create r
  end
end

