class PersonnelSerializer < ActiveModel::Serializer
  attributes :id, :resource_url, :name, :yachtski, :discog_id

  def resource_url
    "/personnel/#{object.id}"
  end

end
