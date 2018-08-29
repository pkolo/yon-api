class ExtendedEpisodeSerializer < EpisodeSerializer
  attributes :id, :number, :show_title, :resource_url, :data_id, :published, :air_date

  has_many :songs, serializer: SongSerializer

  def resource_url
    "/episodes/#{object.id}"
  end

  def show_title
    "#{object.show.title} ##{object.episode_no}"
  end
end
