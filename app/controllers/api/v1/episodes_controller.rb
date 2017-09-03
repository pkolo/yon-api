class Api::V1::EpisodesController < Api::V1::ApiController
  before_action :require_login, only: [:create]

  def show
    @episode = Episode.find(params[:id])
    render json: @episode, serializer: ExtendedEpisodeSerializer
  end

  def create
    @episode = Episode.new(episode_params)
    if @episode.save
      render json: @episode, serializer: ExtendedEpisodeSerializer, status: :created
    else
      errors = @episode.errors.full_messages
      render json: {errors: errors}, status: :unprocessable_entity
    end
  end

  private
    def episode_params
      params.require(:episode).permit(:number, :notes, :link)
    end
end
