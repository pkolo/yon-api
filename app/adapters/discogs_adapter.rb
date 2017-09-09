class DiscogsAdapter
  include StringUtilities
  include TrackMatchUtilities

  def generate_album_params_from(payload, song)
    song_data = get_song_data_from(payload["tracklist"], song)
    binding.pry
    {
      "discog_id": payload["id"],
      # "title": payload["title"],
      "year": payload["year"],
      "artist_credits_attributes": generate_artist_credits_from(payload["artists"]),
      "credits_attributes": generate_credits_from(payload["extraartists"])
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

  def generate_credits_from(credit_list, type="release")
    credit_list.each_with_object([]) do |credit, memo|
      if credit["tracks"].empty? && type == "release"
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

  def get_song_data_from(tracklist, song)
    tracklist.find do |track|
      track if is_match?(track["title"], song.title)
    end
  end

end
