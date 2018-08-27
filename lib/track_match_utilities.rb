require 'fuzzystringmatch'

module TrackMatchUtilities
  def is_match?(str1, str2, strength=0.85)
    fuzzy = FuzzyStringMatch::JaroWinkler.create( :pure )
    match = fuzzy.getDistance(str1, str2)
    match >= strength
  end

  def match_distance(str1, str2)
    fuzzy = FuzzyStringMatch::JaroWinkler.create( :pure )
    fuzzy.getDistance(str1, str2)
  end

  def in_track_range?(all_tracks, person, track_no)
    extract_range = person["tracks"].split(", ").map do |track|
      if track.include?("to")
        range = track.split(" to ")
        start = all_tracks.index(range[0])
        fin = all_tracks.index(range[1])
        (start && fin) ? all_tracks[start..fin] : []
      elsif track.include?("-")
        range = track.split("-")
        start = all_tracks.index(range[0])
        fin = all_tracks.index(range[1])
        (start && fin) ? all_tracks[start..fin] : []
      else
        track
      end
    end
    extract_range.flatten.include?(track_no)
  end
end
