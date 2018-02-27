class HostStatSerializer < ActiveModel::Serializer
  attributes :weird_essentials, :essential, :yacht_rock, :nyacht_rock, :deviation_from_mean, :dissents, :disagreements

  def weird_essentials
    object.weird_essentials.pluck(:data)
  end

  def essential
    object.essential
  end

  def yacht_rock
    object.yacht_rock
  end

  def nyacht_rock
    object.nyacht_rock
  end

  def deviation_from_mean
    object.deviation_from_mean
  end

  def dissents
    all_dissents = object.dissents
    yacht_dissents = all_dissents.first(3).map do |result|
      song = Song.find(result["id"])
      song.data[:dissent] = result["dissent"]
      song.data
    end

    nyacht_dissents = all_dissents.last(3).map do |result|
      song = Song.find(result["id"])
      song.data[:dissent] = result["dissent"]
      song.data
    end

    { yacht: yacht_dissents, nyacht: nyacht_dissents }
  end

  def disagreements
    object.disagreements
  end
end