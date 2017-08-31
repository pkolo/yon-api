class ExtendedEpisodeSerializer < EpisodeSerializer
  has_many :songs, serializer: SongSerializer
end
