# -*- encoding: utf-8 -*-

class GetRecords
  require 'nokogiri'
  require 'open-uri'
  require 'date'
  require 'cgi'

  def self.execute()
    Artist.all.each do |artist|
      url  = REQUEST_SEARCH_URL + CGI.escape(artist.name)
      logs = data_to_hash(get_data_all(url))
      date = Date::today.to_s

      logs.each do |log|
        song = Song.where(:artist_id => artist.id, :title => log[:title])[0]

        # new request
        unless song
          song = Song.create(
            :title      => log[:title] ,
            :request_no => log[:request_no] ,
            :artist_id  => artist.id )
        end

        # seed data modify
        if song.request_no.empty?
          song.request_no = log[:request_no]
          song.save
        end

        # new log
        # if same-day log, not create
        unless Log.where(:song_id => song.id, :date => date)
          Log.create(
            :song_id => song.id ,
            :rank    => log[:rank] ,
            :point   => log[:point] ,
            :date    => date )
        end
      end
    end
  end

  def self.get_data_all(url)
    page = open(url)
    html = Nokogiri::HTML(page.read, nil, 'UTF-8')
    block = html.css('div.requestTable01 tbody tr')
    next20 = html.css('table tr td a').select{|a| a.inner_text.start_with?('次の20件')}

    block = block[1..-1].map do |tr|
      reqest_id = /requestNo=(\d+)/.match(tr.css('td a').first[:href])
      tr.css('td').map{|x| x.inner_text}[1..-2] << reqest_id[1]
    end

    if not next20.empty? and /offset=(\d+)/ =~ next20[0][:href]
      offset = $&
      next_url = url.gsub(/&offset=\d+/, '') + '&' + offset

      block.concat(get_data_all(next_url))
    end

    block
  end

  def self.data_to_hash(data_array)
    data_array.map do |data|
      {
        :rank       => data[0].to_i ,
        :title      => data[1] ,
        :artist     => data[2] ,
        :point      => data[4][0..-2].to_i ,
        :request_no => data[5] ,
      }
    end
  end

  private_class_method :get_data_all
  private_class_method :data_to_hash
end

