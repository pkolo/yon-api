class Api::V1::CreditsController < Api::V1::ApiController

  before_action :require_login, only: [:index]
  before_action :find_song, only: [:index]

  def index
    @credits = @song.credits
    render json: @credits.to_json
  end

  private
    def song_id_params
      params.require(:song_id)
    end

    def find_song
      @song = Song.find(song_id_params)
    end

end
