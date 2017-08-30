class ExtendedPersonnelSerializer < PersonnelSerializer
  attributes :song_credits, :album_credits
  has_many :songs_as_artist

  def song_credits
    get_media_for(object.credits_for "songs")
  end

  def album_credits
    get_media_for(object.credits_for "albums")
  end

  def get_media_for(credits)
    credits.map do |credit|
      {
        media: credit["type"].constantize.find(credit["id"]),
        roles: credit["roles"].split(", ")
      }
    end
  end

end
