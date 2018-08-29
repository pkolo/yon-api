class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :number, :show_title, :resource_url, :data_id, :published, :air_date

  def resource_url
    "/episodes/#{object.id}"
  end

  def number
    "#{object.show.abbreviation}#{object.episode_no}"
  end

  def show_title
    "#{object.show.title} ##{object.episode_no}"
  end
end
