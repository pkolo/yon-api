class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :year

  has_many :players
  has_many :artists

  def url
    "/album/#{object.slug}"
  end

end
