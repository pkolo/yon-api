class SongSerializer < ActiveModel::Serializer
  attributes :id, :resource_url, :title, :track_no, :yt_id, :year, :yachtski, :scores, :episode

  has_many :artists
  has_many :featured_artists

  def resource_url
    "/songs/#{object.id}"
  end

  def scores
    {
      jd: object.jd_score,
      hunter: object.hunter_score,
      steve: object.steve_score,
      dave: object.dave_score
    }
  end

  def episode
    object.episodes.first
  end
end
