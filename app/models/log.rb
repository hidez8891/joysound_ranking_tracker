class Log < ActiveRecord::Base
  include ActiveRecord::Calculations

  attr_accessible :song_id, :rank, :point, :date
  validate :song_id, :rank, :point, :date, presence: true

  belongs_to :song

  def self.latest_day
    maximum(:date)
  end

  def self.latest_logs (order = 'rank asc')
    where(:date => latest_day).order(order)
  end

  def previous_day
    Log
      .where(:song_id => song_id)
      .where('date < ?', date)
      .order('date desc')
      .first
  end
end
