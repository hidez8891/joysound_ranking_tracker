class Song < ActiveRecord::Base
  include ActiveRecord::Calculations

  attr_accessible :title, :request_no, :artist_id
  validate :title, :request_no, :artist_id, presence: true

  belongs_to :artist
  has_many :logs

  def latest_log
    logs.order('date desc').first
  end
end
