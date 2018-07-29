class Api::V1::EpisodesController < Api::V1::ApiController
  before_action :require_login, only: [:create, :update]

  def index
    @episodes = Episode.all.order('id DESC')
    render json: @episodes
  end

  def show
    @episode = Episode.find(params[:id])
    render json: @episode, serializer: ExtendedEpisodeSerializer
  end

  def create
    @episode = Episode.new(episode_params)
    @show = Show.find_by(abbreviation: episode_params[:number].gsub(/\d+/, ''))
    @episode.show = @show
    if @episode.save
      render json: @episode, serializer: ExtendedEpisodeSerializer, status: :created
    else
      errors = @episode.errors.full_messages
      render json: {errors: errors}, status: :unprocessable_entity
    end
  end

  def update
    @episode = Episode.find(params[:id])

    if @episode.update_attributes(episode_params)
      render json: @episode, serializer: ExtendedEpisodeSerializer
    else
      errors = @episode.errors.full_messages
      render json: {errors: errors}, status: :unprocessable_entity
    end
  end

  private
    def episode_params
      params.require(:episode).permit(:number, :title, :notes, :link, :published)
    end
end
