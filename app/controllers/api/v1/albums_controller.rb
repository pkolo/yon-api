class Api::V1::AlbumsController < Api::V1::ApiController

  before_action :require_login, only: [:create]
  before_action :find_song, only: [:create]

  def show
    @album = Album.find(params[:id])
    render json: @album, serializer: ExtendedAlbumSerializer
  end

  # Nested through song
  def create
    @album = Album.find_by(album_params)
    discogs = DiscogsApi.new(type: "release", id: album_params["discog_id"])
    album_data = discogs.get_data
    adapter = DiscogsAdapter.new
    params = adapter.generate_album_params_from(album_data, @song)
    binding.pry
    if @album
      render json: @album, status: :created
    else
      @album = Album.new(params)
      if @album.save
        render json: @album, status: :created
      else
        render json: {errors: @album.errors.full_messages}, status: :unprocessable_entity
      end
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
