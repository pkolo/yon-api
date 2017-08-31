class Api::V1::SongsController < Api::V1::ApiController
  def index
    @songs = Song.all.order("yachtski DESC")
    render json: @songs
  end

  def show
    @song = Song.find(params[:id])
    render json: @song, serializer: ExtendedSongSerializer
  end

  def create
    @episode = Episode.find(params[:episode_id])
    @song = Song.new(song_params)
    if @song.save
      @episode.songs << @song
      render json: @song, status: :created
    else
      render json: {errors: @song.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
    def song_params
      params.require(:song).permit(:title, :year, :jd_score, :dave_score, :hunter_score, :steve_score, personnel_attributes: => [:name])
    end
end
