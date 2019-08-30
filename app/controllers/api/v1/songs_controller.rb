class Api::V1::SongsController < Api::V1::ApiController
  before_action :require_login, only: [:create]
  before_action :find_episode, only: [:create]

  def index
    @songs = Song.published.pluck(:data)

    render json: @songs
  end

  def show
    @song = Song.find(params[:id])

    render json: SongSerializer.render(@song, view: :extended)
  end

  def create
    @song = Song.new(song_params)
    @song.episodes << @episode

    if @song.save
      render json: SongSerializer.render(@song, view: :basic), status: :created
    else
      render json: {errors: @song.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    @song = Song.find(params[:id])

    if @song.update(song_params)
      render json: SongSerializer.render(@song, view: :extended)
    else
      render json: {errors: @song.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
    def song_params
      params.require(:song).permit(:title, :year, :jd_score,
        :dave_score, :hunter_score, :steve_score,
        credits_attributes: [:role,
          personnel_attributes: [:discog_id, :name]
        ]
      )
    end

    def episode_id_params
      params.require(:episode_id)
    end

    def find_episode
      @episode = Episode.find(episode_id_params)
    end
end
