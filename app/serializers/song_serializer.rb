class SongSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :track_no, :yt_id, :year, :yachtski, :scores

  has_many :artists
  has_many :featured_artists
  belongs_to :episode

  def url
    "/songs/#{object.slug}"
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
