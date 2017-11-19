class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :year, :yachtski

  has_many :players
  has_many :artists

  def url
    "/albums/#{object.slug}"
  end

end
