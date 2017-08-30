class Song < ActiveRecord::Base
  belongs_to :album
  has_many :credits, as: :creditable, dependent: :destroy
  has_many :artists, ->(credit) { where 'credits.role IN (?)', ["Artist"] }, through: :credits, source: :personnel
  has_many :featured_artists, ->(credit) { where 'credits.role IN (?)', ["Featuring", "Duet"] }, through: :credits, source: :personnel

  def players
    query = <<-SQL
      SELECT p.id, p.name, p.yachtski, concat('/personnel/', p.slug) AS url, string_agg(c.role, ', ') AS roles
      FROM personnels p JOIN credits c ON p.id=c.personnel_id
      WHERE c.creditable_id=#{self.id} AND c.creditable_type='#{self.class}' AND c.role NOT IN ('Artist', 'Duet', 'Featuring')
      GROUP BY p.id
      ORDER BY p.yachtski DESC
      SQL
    ActiveRecord::Base.connection.execute(query)
  end
end
