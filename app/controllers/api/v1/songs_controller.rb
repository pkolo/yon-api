class Api::V1::SongsController < Api::V1::ApiController
  before_action :require_login, only: [:create]
  before_action :find_episode, only: [:create]

  def index
    @songs = Song.published.pluck(:data)
    render json: @songs, adapter: false
  end

  def show
    @song = Song.find(params[:id])
    render json: @song, serializer: ExtendedSongSerializer
  end

  def create
    @song = Song.new(song_params)
    @song.episodes << @episode
    if @song.save
      render json: @song, status: :created
    else
      render json: {errors: @song.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
    def song_params
      params.require(:song)
            .permit(:title, :year, :jd_score, :dave_score, :hunter_score, :steve_score, :credits_attributes => [:role, :personnel_attributes => [:id, :name]])
    end

    def episode_id_params
      params.require(:episode_id)
    end

    def find_episode
      @episode = Episode.find(episode_id_params)
    end
end
