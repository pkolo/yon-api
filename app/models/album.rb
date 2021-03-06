class Album < ActiveRecord::Base
  scope :yacht_rock, -> { where('yachtski >= 50') }

  after_touch :update_yachtski
  after_update :destroy_duplicate_credits

  has_many :songs
  has_many :credits, as: :creditable
  has_many :artist_credits, ->(credit) { where 'credits.role IN (?)', ["Artist"] }, class_name: 'Credit', as: :creditable
  has_many :personnel, through: :credits, dependent: :destroy
  has_many :artists, ->(credit) { where 'credits.role IN (?)', ["Artist"] }, through: :credits, source: :personnel
  has_many :featured_artists, ->(credit) { where 'credits.role IN (?)', ["Featuring", "Duet"] }, through: :credits, source: :personnel

  def players
    query = <<-SQL
      SELECT p.id, p.name, p.yachtski, concat('/personnel/', p.id) AS resource_url, string_agg(c.role, ', ') AS roles
      FROM personnels p JOIN credits c ON p.id=c.personnel_id
      WHERE c.creditable_id=#{self.id} AND c.creditable_type='#{self.class}' AND c.role NOT IN ('Artist', 'Duet', 'Featuring')
      GROUP BY p.id
      ORDER BY p.yachtski DESC
      SQL
    ActiveRecord::Base.connection.execute(query)
  end

  accepts_nested_attributes_for :credits
  accepts_nested_attributes_for :artist_credits
  accepts_nested_attributes_for :songs

  validates :discog_id, presence: true
  validates :title, presence: true

  def update_yachtski
    update(yachtski: calculate_yachtski)
  end

  def calculate_yachtski
    songs.average(:yachtski).to_f
  end

  def destroy_duplicate_credits
    credits.where.not(id: credits.group(:personnel_id, :role).pluck('min(id)')).destroy_all
  end
end
