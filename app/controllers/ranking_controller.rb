class RankingController < ApplicationController
  def index
    @artists = Artist.order(:name)
    @ranking = Log.latest_logs
    @latestday = @ranking.first.date
    respond_to do |format|
      format.html
    end
  end
end
