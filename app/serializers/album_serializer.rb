class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :year, :players

  has_many :songs, if: :extended?

  def extended?
    instance_options[:extended]
  end

  def url
    "/album/#{object.slug}"
  end

end
