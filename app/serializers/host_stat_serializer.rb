class HostStatSerializer < Blueprinter::Base
  field :host do |object|
    object.host
  end

  field :all_hosts do |object|
    Host.all.as_json
  end

  field :essential do |object|
    object.essential
  end

  field :yacht_rock do |object|
    object.yacht_rock
  end

  field :nyacht_rock do |object|
    object.nyacht_rock
  end

  field :deviation_from_mean do |object|
    object.deviation_from_mean
  end

  field :dissents do |object|
    all_dissents = object.dissents
    yacht_dissents = all_dissents.first(3).map do |result|
      song = Song.find(result["id"])
      song.data[:dissent] = result["dissent"]
      song.data
    end

    nyacht_dissents = all_dissents.last(3).reverse.map do |result|
      song = Song.find(result["id"])
      song.data[:dissent] = result["dissent"]
      song.data
    end

    { yacht: yacht_dissents, nyacht: nyacht_dissents }
  end

  field :disagreements do |object|
    object.disagreements
  end

  field :weird_essentials do |object|
    object.weird_essentials.pluck(:data)
  end
end
