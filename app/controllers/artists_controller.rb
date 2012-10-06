class ArtistsController < ApplicationController
  def index
    @current_artist = Artist.find(params[:id])
    @ranking = @current_artist.latest_logs
    @latestday = Log.latest_day
    respond_to do |format|
      format.html
      format.json { render json: _graph }
    end
  end

  private
  def _graph
    @current_artist.songs.map do |song|
      logs = song.logs.order('date asc').map do |log|
        {
          :date => log.date ,
          :rank => log.rank ,
          :point => log.point
        }
      end

      {
        :title => song.title ,
        :logs  => logs
      }
    end
  end
end
