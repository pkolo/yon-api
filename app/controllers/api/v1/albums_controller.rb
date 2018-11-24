class Api::V1::AlbumsController < Api::V1::ApiController

  before_action :require_login, only: [:create]
  before_action :find_song, only: [:create, :search]

  def show
    @album = Album.find(params[:id])
    render json: @album, serializer: ExtendedAlbumSerializer
  end

  # Nested through song
  def create
    @album = Album.find_or_initialize_by(album_params)
    params = get_album_data

    @song.player_credits.destroy_all if @song.player_credits.any?

    if @album.update(params)
      render json: @song, serializer: ExtendedSongSerializer, status: :created
    else
      errors = @album.errors.full_messages
      render json: {errors: errors}, status: :unprocessable_entity
    end
  end

  def search
    options = {options: {artist: @song.artists.first[:name], title: @song.title}}
    discogs = Api::DiscogsApi.new(options)
    search_data = discogs.search
    album_ids = search_data.map {|r| r["id"].to_s}
    matches = Album.where(discog_id: album_ids)

    if matches.length > 1
      existing = []
      matches.each { |album| existing << {title: "#{album.title}", year: album.year, id: album.discog_id, url: "http://discogs.com/release/#{album.discog_id}"} }

      render json: { errors: ["Multiple matching albums."], existing: existing }, status: :unprocessable_entity
    elsif matches.any?
      @album = Album.find_or_initialize_by(discog_id: matches.first.discog_id)
      params = get_album_data

      if @album.update(params)
        @song.update_data
        render json: @song, serializer: ExtendedSongSerializer, status: :created
      else
        errors = @album.errors.full_messages
        render json: {errors: errors}, status: :unprocessable_entity
      end
    else
      existing = []
      @song.artists.each do |artist|
        artist.albums.each { |album| existing << {title: "#{artist.name} - #{album.title}", year: album.year, id: album.discog_id, url: "http://discogs.com/release/#{album.discog_id}"} }
      end

      suggestions = search_data.map {|r| {title: r["title"], year: r["year"], id: r["id"], url: "http://discogs.com/#{r["uri"]}"}}
      render json: {errors: ["No matching albums."], existing: existing, suggestions: suggestions}, status: :unprocessable_entity
    end
  end

  private
    def album_params
      params.require(:album).permit(:discog_id)
    end

    def get_album_data
      discogs = Api::DiscogsApi.new(type: "release", id: @album.discog_id)
      album_data = discogs.get_data
      adapter = DiscogsAdapter.new(album_data, @song, @album)
      adapter.generate_album_params
    end

    def song_id_params
      params.require(:song_id)
    end

    def find_song
      @song = Song.find(song_id_params)
    end

end
