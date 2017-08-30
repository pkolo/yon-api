class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :year, :players

  def url
    "/album/#{object.slug}"
  end

end
