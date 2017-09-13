class Api::V1::AlbumsController < Api::V1::ApiController

  before_action :require_login, only: [:create]
  before_action :find_song, only: [:create]

  def show
    @album = Album.find(params[:id])
    render json: @album, serializer: ExtendedAlbumSerializer
  end

  # Nested through song
  def create
    @album = Album.find_or_initialize_by(album_params)
    discogs = Api::DiscogsApi.new(type: "release", id: album_params["discog_id"])
    album_data = discogs.get_data
    adapter = DiscogsAdapter.new(album_data, @song, @album)
    params = adapter.generate_album_params

    if @album.update(params)
      render json: @album, status: :created
    else
      errors = @album.errors.full_messages
      render json: {errors: errors}, status: :unprocessable_entity
    end
  end

  private
    def album_params
      params.require(:album).permit(:discog_id)
    end

    def song_id_params
      params.require(:song_id)
    end

    def find_song
      @song = Song.find(song_id_params)
    end

end
