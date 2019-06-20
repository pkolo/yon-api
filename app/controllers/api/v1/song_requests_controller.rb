class Api::V1::SongRequestsController < Api::V1::ApiController
  before_action :require_login, only: [:index, :update]

  def index
    song_requests = SongRequest.all.order(created_at: :desc, rated_at: :desc)

    render json: song_requests
  end

  def create
    song_request = SongRequest.new(song_request_params)

    if song_request.save
      render json: song_request
    else
      render json: { errors: song_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    song_request = SongRequest.find(params[:id])

    if song_request.update(song_request_params)
      render json: song_request
    else
      render json: { errors: song_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def song_request_params
    params.require(:song_request).permit(:name, :title, :artist, :link, :message, :source, :rated_at)
  end
end
