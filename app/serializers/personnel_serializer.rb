class PersonnelSerializer < ActiveModel::Serializer
  attributes :id, :url, :name

  def url
    "/personnel/#{object.slug}"
  end

end
