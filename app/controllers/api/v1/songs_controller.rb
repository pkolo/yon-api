class Api::V1::SongsController < Api::V1::ApiController
  before_action :require_login, only: [:create]
  before_action :find_episode, only: [:create]

  def index
    render json: fetch_songs
  end

  def show
    @song = Song.find(params[:id])
    render json: @song, serializer: ExtendedSongSerializer
  end

  def create
    @song = Song.new(song_params)
    @song.episode = @episode
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

    def fetch_songs
      songs_cache = $redis.get("songs")
      if songs_cache.nil?
        songs = Song.includes(:personnel).all
        songs_resource = ActiveModelSerializers::SerializableResource.new(songs, each_serializer: SongSerializer)
        songs_object = songs_resource.to_json
        $redis.set("songs", songs_object)
        $redis.expire("songs", 10.day.to_i)
      end
      songs_cache
    end
end
