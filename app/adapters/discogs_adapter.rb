class DiscogsAdapter
  include StringUtilities
  include TrackMatchUtilities

  def generate_album_params_from(payload, song)
    song_data = get_song_data_from(payload["tracklist"], song)
    {
      "discog_id": payload["id"],
      # "title": payload["title"],
      "year": payload["year"],
      "artist_credits_attributes": generate_artist_credits_from(payload["artists"]),
      "credits_attributes": generate_album_credits_from(payload["extraartists"]),
      "songs_attributes": {
        "id": song.id,
        "title": song_data.title,
        "artists_attributes": generate_artist_credits_from(payload["artists"]),
        "credits_attributes": generate_song_credits_from(song_data["extraartists"]),
      }
    }
  end

  def generate_artist_credits_from(credit_list)
    credit_list.each_with_object([]) do |credit, memo|
      memo << {
        "role": "Artist",
        "personnel_attributes": {
          "name": remove_parens(credit["name"]),
          "discog_id": credit["id"]
        }
      }
    end
  end

  def generate_album_credits_from(credit_list)
    credit_list.each_with_object([]) do |credit, memo|
      if credit["tracks"].empty?
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
  end

  def generate_song_credits_from(credit_list)

  end

  def get_song_data_from(tracklist, song)
    tracklist.find do |track|
      track if is_match?(track["title"], song.title)
    end
  end

end
