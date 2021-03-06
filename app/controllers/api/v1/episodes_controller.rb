class Api::V1::EpisodesController < Api::V1::ApiController
  before_action :require_login, only: [:create, :update]

  def index
    @episodes = Episode.all.order('id DESC')
    render json: EpisodeSerializer.render(@episodes, view: :basic)
  end

  def show
    @episode = Episode.find(params[:id])
    render json: EpisodeSerializer.render(@episode, view: :extended)
  end

  def create
    @episode = Episode.new(episode_params)

    if @episode.save
      render json: EpisodeSerializer.render(@episode, view: :basic)
    else
      errors = @episode.errors.full_messages
      render json: {errors: errors}, status: :unprocessable_entity
    end
  end

  def update
    @episode = Episode.find(params[:id])

    if @episode.update(episode_params)
      render json: EpisodeSerializer.render(@episode, view: :extended)
    else
      errors = @episode.errors.full_messages
      render json: {errors: errors}, status: :unprocessable_entity
    end
  end

  private
    def episode_params
      params.require(:episode).permit(:episode_no, :title, :notes,
        :link, :published, :description, :show_id)
    end
end
