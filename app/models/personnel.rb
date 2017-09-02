class Personnel < ActiveRecord::Base
  has_many :credits

  has_many :songs, -> { distinct }, through: :credits, source: :creditable, source_type: 'Song'
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

end
