class EpisodeSerializer < Blueprinter::Base
  identifier :id

  view :basic do
    fields :id, :number, :show_title, :resource_url, :data_id, :published, :air_date

    field :resource_url do |object|
      "/episodes/#{object.id}"
    end

    field :number do |object|
      "#{object.show.abbreviation}#{object.episode_no}"
    end

    field :show_title do |object|
      "#{object.show.title} ##{object.episode_no}"
    end
  end

  view :extended do
    include_view :basic

    association :songs, blueprint: SongSerializer, view: :basic

    fields :title, :description
  end
end
