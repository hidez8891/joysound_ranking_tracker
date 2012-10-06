class SongsController < ApplicationController
  def index
    @current_song = Song.find(params[:id])
    @current_artist = @current_song.artist
    @latestday = @current_song.logs.order('date desc').first.date
    respond_to do |format|
      format.html
      format.json { render json: _graph }
    end
  end

  private
  def _graph
    logs = @current_song.logs.order('date asc').map do |log|
      {
        :date => log.date ,
        :rank => log.rank ,
        :point => log.point
      }
    end

    [{
      :title => @current_song.title ,
      :logs  => logs
    }]
  end
end
