class Artist < ActiveRecord::Base
  include ActiveRecord::Calculations

  attr_accessible :name
  validates :name, presence: true

  has_many :songs

  def latest_logs (order = 'rank')
    latestday = Log.latest_day
    songs
      .map{|song| song.latest_log}
      .select{|log| log.date == latestday}
      .sort{|a, b| a.send(order) <=> b.send(order)}
  end

  def latest_rankings
    songs.map{|song| song.latest_log}.sort{|a, b| a.rank <=> b.rank}
  end

  def all_logs
    songs.order(:title).map do |song|
      {
        :title => song.title ,
        :logs  => song.all_logs
      }
    end
  end
end
