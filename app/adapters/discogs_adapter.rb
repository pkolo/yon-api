class DiscogsAdapter
  attr_accessor :song_payload

  include StringUtilities
  include TrackMatchUtilities

  def initialize(payload, song, album)
    @payload = payload
    @song = song
    @album = album
  end

  def generate_album_params
    full_album_credits = isolate_album_credits
    @song_payload = get_song_data
    artist_credits = generate_artist_credits_from(@payload["artists"])
    song_credits = @song_payload["extraartists"] || []
    extra_song_credits = isolate_song_credits
    {
      "discog_id": @payload["id"],
      "title": @payload["title"],
      "year": @payload["year"],
      "artist_credits_attributes": artist_credits,
      "credits_attributes": generate_credits_from(full_album_credits),
      "song_ids": @album.songs.pluck(:id) + [@song.id],
      "songs_attributes": [{
        "id": @song.id,
        "title": @song_payload["title"],
        "track_no": @song_payload["position"],
        "artist_credits_attributes": artist_credits,
        "credits_attributes": generate_credits_from(song_credits + extra_song_credits),
      }]
    }
  end

  def isolate_album_credits
    @payload["extraartists"].select { |credit| credit["tracks"].empty? }
  end

  def isolate_song_credits
    track_range = @payload["tracklist"].map {|track| track["position"]}
    @payload["extraartists"].select { |credit| in_track_range?(track_range, credit, @song_payload["position"]) }
  end

  def generate_artist_credits_from(credit_list)
    credit_list.each_with_object([]) do |credit, memo|
      memo << {
        "role": "Artist",
        "personnel_attributes": {
          "name": remove_parens(credit["name"]),
          "discog_id": credit["id"].to_s
        }
      }
    end
  end

  def generate_credits_from(credit_list)
    credit_list.each_with_object([]) do |credit, memo|
      credit["role"].split(', ').each do |role|
        memo << {
          "role": role,
          "personnel_attributes": {
            "name": remove_parens(credit["name"]),
            "discog_id": credit["id"]
          }
        }
      end
    end
  end

  def get_song_data
    match = {}
    strength = 85.0
    @payload["tracklist"].each do |track|
      match_strength = match_distance(remove_parens(track["title"]).downcase, remove_parens(@song.title).downcase)

      if match_strength > strength
        strength = match_strength
        match = track
      end

    end
    match
  end

end
