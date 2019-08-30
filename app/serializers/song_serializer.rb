class SongSerializer < Blueprinter::Base
  identifier :id

  fields :title, :yachtski

  association :artists, blueprint: PersonnelSerializer, view: :basic
  association :featured_artists, blueprint: PersonnelSerializer, view: :basic

  field :resource_url do |object|
    "/songs/#{object.id}"
  end

  view :basic do
    fields :track_no, :yt_id, :year

    association :episodes, blueprint: EpisodeSerializer, view: :basic

    field :discog_id do |object|
      object.album&.discog_id
    end

    field :scores do |object|
      {
        jd: object.jd_score,
        hunter: object.hunter_score,
        steve: object.steve_score,
        dave: object.dave_score
      }
    end
  end

  view :extended do |object|
    include_view :basic

    association :album, blueprint: AlbumSerializer, view: :basic

    field :players do |object|
      object.players.as_json
    end
  end
end
