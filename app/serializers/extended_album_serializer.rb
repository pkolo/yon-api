class ExtendedAlbumSerializer < AlbumSerializer
  field :songs do |object|
    object.songs
  end
end
