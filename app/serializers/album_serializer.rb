class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :resource_url, :title, :year, :yachtski

  has_many :players
  has_many :artists

  def resource_url
    "/albums/#{object.id}"
  end

end
