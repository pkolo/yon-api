class Api::V1::AlbumsController < ApplicationController
  before_action :require_login, only: [:create]
  before_action :find_song, only: [:create]

  def show
    @album = Album.find(params[:id])
    render json: @album, serializer: ExtendedAlbumSerializer
  end

  # Nested through song
  def create
    
  end

  private
    def album_params
      params.require(:album).permit(:discog_id)
    end

    def song_id_params
      params.require(:song_id)
    end

    def find_song
      @song = Song.find(song_id_params)
    end

end
