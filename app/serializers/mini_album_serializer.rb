class MiniAlbumSerializer < ActiveModel::Serializer
  attributes :url, :title, :yachtski

  has_many :artists
  has_many :featured_artists

  def url
    "/albums/#{object.slug}"
  end
end
