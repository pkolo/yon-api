require 'fuzzystringmatch'

module TrackMatchUtilities
  def is_match?(str1, str2, strength=0.85)
    fuzzy = FuzzyStringMatch::JaroWinkler.create( :pure )
    match = fuzzy.getDistance(str1, str2)
    match >= strength
  end
end
