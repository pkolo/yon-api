class PersonnelSerializer < ActiveModel::Serializer
  attributes :id, :resource_url, :name, :yachtski

  def resource_url
    "/personnel/#{object.id}"
  end

end
