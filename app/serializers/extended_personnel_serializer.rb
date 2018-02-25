class ExtendedPersonnelSerializer < PersonnelSerializer

  attributes :song_credits, :album_credits, :frequent_roles
  has_many :songs_as_artist

  def song_credits
    get_media_for(object.credits_for("songs"), Song)
  end

  def album_credits
    get_media_for(object.credits_for("albums"), Album)
  end

  def get_media_for(credits, type)
    serializer = "Mini#{type}Serializer".constantize
    credits.map do |credit|
      media = type.find(credit["id"])
      song_resource = ActiveModelSerializers::SerializableResource.new(media, serializer: serializer)
      song_object = song_resource.as_json
      {
        media: song_object,
        roles: credit["roles"]
      }
    end
  end
end
