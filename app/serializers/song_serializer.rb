class SongSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :year, :yachtski, :scores
  attribute :players, if: :extended?

  has_many :artists
  has_many :featured_artists
  belongs_to :album, if: :has_album?, if: :extended?

  def extended?
    instance_options[:extended]
  end

  def has_album?
    object.album
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
