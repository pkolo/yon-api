class MiniSongSerializer < ActiveModel::Serializer
  attributes :id, :resource_url, :title, :yachtski

  has_many :artists
  has_many :featured_artists

  def resource_url
    "/songs/#{object.id}"
  end
end
