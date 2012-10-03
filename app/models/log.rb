class Log < ActiveRecord::Base
  attr_accessible :song_id, :rank, :point, :date
  validate :song_id, :rank, :point, :date, presence: true

  belongs_to :songs
end
