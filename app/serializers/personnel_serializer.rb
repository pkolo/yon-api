class PersonnelSerializer < ActiveModel::Serializer
  attributes :id, :url, :name, :yachtski

  def url
    "/personnel/#{object.slug}"
  end

end
