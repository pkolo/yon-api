class PersonnelSerializer < Blueprinter::Base
  identifier :id

  view :basic do
    fields :id, :name, :yachtski, :discog_id

    field :resource_url do |object|
      "/personnel/#{object.id}"
    end
  end

  view :extended do
    include_view :basic

    association :songs_as_artist, blueprint: SongSerializer, view: :basic

    field :song_credits do |object|
      credits = object.credits_for("songs")
      credits.map do |credit|
        media = Song.find(credit["id"])
        json = SongSerializer.render_as_json(media)

        {
          media: json,
          roles: credit["roles"]
        }
      end
    end

    field :album_credits do |object|
      credits = object.credits_for("albums")
      credits.map do |credit|
        media = Album.find(credit["id"])
        json = AlbumSerializer.render_as_json(media)

        {
          media: json,
          roles: credit["roles"]
        }
      end
    end

    field :frequent_roles do |object|
      object.frequent_roles
    end
  end
end
