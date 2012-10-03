class Song < ActiveRecord::Base
  attr_accessible :title, :request_no, :artist_id
  validate :title, :request_no, :artist_id, presence: true

  belongs_to :artists
  has_many :logs
end
