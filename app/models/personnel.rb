class Personnel < ActiveRecord::Base
  after_touch :update_yachtski

  has_many :credits, dependent: :destroy

  has_many :songs, -> { distinct }, through: :credits, source: :creditable, source_type: 'Song'
  has_many :albums_from_songs, -> { distinct }, through: :songs, source: :album
  has_many :albums, -> { distinct }, through: :credits, source: :creditable, source_type: 'Album'


  has_many :songs_as_artist, ->(credit) { where 'credits.role = ?', "Artist" }, through: :credits, source: :creditable, source_type: 'Song'

  # Retrieves all of a person's combined credited roles on a given media type, "songs" or "albums".
  def credits_for(table)
    query = <<-SQL
      SELECT #{table}.id, c.creditable_type AS type, string_agg(c.role, ', ') AS roles
      FROM #{table}
      JOIN credits c ON c.creditable_id=#{table}.id AND c.creditable_type=\'#{table[0..-2].capitalize}\'
      WHERE c.personnel_id=#{self.id} AND c.role NOT IN ('Artist', 'Duet', 'Featuring')
      GROUP BY #{table}.id, c.creditable_type
      ORDER BY #{table}.yachtski DESC
    SQL
    ActiveRecord::Base.connection.execute(query)
  end

  validates :name, presence: true

  def update_yachtski
    update(yachtski: calculate_yachtski) if total_credited_media > 0
  end

  def calculate_yachtski
    (songs.pluck(:yachtski) + albums_performed_on.pluck(:yachtski)).sum / total_credited_media
  end

  def total_credited_media
    songs.size + albums_performed_on.size
  end

  def albums_performed_on
    albums.where.not(id: albums_from_songs.pluck(:id))
  end

  def has_discog?
    !!discog_id
  end

end
