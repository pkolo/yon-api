class AlbumSerializer < Blueprinter::Base
  identifier :id

  fields :id, :resource_url, :title, :yachtski

  association :artists, blueprint: PersonnelSerializer, view: :basic
  association :featured_artists, blueprint: PersonnelSerializer, view: :basic

  field :resource_url do |object|
    "/albums/#{object.id}"
  end

  view :basic do
    fields :year, :discog_id

    field :players do |object|
      object.players.as_json
    end
  end

  view :extended do
    include_view :basic

    association :songs, blueprint: SongSerializer, view: :basic
  end
end
