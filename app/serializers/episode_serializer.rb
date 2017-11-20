class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :number, :link, :title, :resource_url

  def resource_url
    "/episodes/#{object.id}"
  end

  def title
    if object.number.match('YON')
      object.number.gsub('YON', 'Yacht Or Nyacht #')
    elsif object.number.match('BRC')
      object.number.gsub('BRC', 'Beyond Yacht Rock Record Club #')
    else
      object.number.gsub('BYR', 'Beyond Yacht Rock #')
    end
  end
end
