class ExtendedEpisodeSerializer < EpisodeSerializer
  attributes :title

  has_many :songs, serializer: SongSerializer

  def title
    object.title
  end
end
