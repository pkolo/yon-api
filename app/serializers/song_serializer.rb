class SongSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :year, :yachtski, :scores

  has_many :artists
  has_many :featured_artists
  has_many :credits, if: :details_enabled?

  def details_enabled?
    instance_options[:details]
  end

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
