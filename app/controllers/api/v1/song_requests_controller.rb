class Api::V1::SongRequestsController < Api::V1::ApiController
  def create
    song_request = SongRequest.create(song_request_params)

    if song_request
      render json: song_request
    else
      render json: { errors: song_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def song_request_params
    params.require(:song_request).permit(:name, :title, :artist, :link, :message)
  end
end
