class ExtendedSongSerializer < SongSerializer
  attributes :players

  belongs_to :album, if: :has_album?

  def has_album?
    object.album
  end
end
