class SongSerializer < ActiveModel::Serializer
  attributes :id, :resource_url, :title, :track_no, :yt_id, :year, :yachtski, :scores

  has_many :artists
  has_many :featured_artists
  has_many :episodes

  def resource_url
    "/songs/#{object.id}"
  end

  def discog_id
    object.album ? object.album.discog_id : null
  end

  def scores
    {
      jd: object.jd_score,
      hunter: object.hunter_score,
      steve: object.steve_score,
      dave: object.dave_score
    }
  end
end
