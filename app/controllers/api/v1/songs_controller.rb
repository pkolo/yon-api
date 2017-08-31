class Api::V1::SongsController < Api::V1::ApiController
  def index
    @songs = Song.all.order("yachtski DESC")
    render json: @songs
  end

  def show
    @song = Song.find(params[:id])
    render json: @song, serializer: ExtendedSongSerializer
  end
end
