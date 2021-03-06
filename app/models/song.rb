class Song < ActiveRecord::Base
  scope :yacht_rock, -> { where('yachtski >= 50') }
  scope :essential, -> { where('yachtski >= 90') }
  scope :not_essential, -> { where('yachtski < 90') }
  scope :nyacht_rock, -> { where('yachtski < 50') }
  scope :published, -> { joins(:episodes).where('episodes.published = true') }

  before_save :update_yachtski
  after_save :destroy_temp_credits
  after_save :update_data
  after_update :update_personnel_yachtski
  after_update :update_yt_id
  after_destroy :destroy_album, if: :album_is_orphan?

  belongs_to :album, optional: true, touch: true
  has_and_belongs_to_many :episodes
  has_many :credits, as: :creditable
  has_many :artist_credits, ->(credit) { where 'credits.role IN (?)', ["Artist", "Temp Artist"] }, class_name: 'Credit', as: :creditable
  has_many :player_credits, ->(credit) { where 'credits.role NOT IN (?)', ["Artist", "Temp Artist"] }, class_name: 'Credit', as: :creditable
  has_many :personnel, through: :credits, dependent: :destroy
  has_many :artists, ->(credit) { where 'credits.role IN (?)', ["Artist", "Temp Artist"] }, through: :credits, source: :personnel
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

  validates :title,        presence: true
  validates :year,         presence: true, numericality: { only_integer: true, greater_than: 1850, less_than_or_equal_to: Date.today.year }
  validates :jd_score,     presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :hunter_score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :steve_score,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :dave_score,   presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def update_yachtski
    self.yachtski = (jd_score + hunter_score + steve_score + dave_score) / 4
  end

  def update_yt_id
    search_params = {artist: artists.pluck(:name), title: title}
    youtube = Api::YoutubeApi.new(search_params)
    new_yt_id = youtube.search
    self.update_columns yt_id: new_yt_id
  end

  def update_data
    song_data = ActiveModelSerializers::SerializableResource.new(self, serializer: SongSerializer)
    self.update_columns data: song_data.as_json
  end

  def update_personnel_yachtski
    self.personnel.each { |person| person.update_yachtski }
  end

  def destroy_temp_credits
    self.credits.where(role: "Temp Artist").destroy_all if self.album
  end

  def album_is_orphan?
    self.album && self.album.songs.empty?
  end

  def destroy_album
    self.album.destroy
  end

  def destroy_duplicate_credits
    credits.where.not(id: credits.group(:personnel_id, :role).pluck('min(id)')).destroy_all
  end

  def self.refresh_cache
    songs = self.includes(:personnel).all
    songs_resource = ActiveModelSerializers::SerializableResource.new(songs, each_serializer: SongSerializer)
    songs_object = songs_resource.to_json
    $redis.set("songs", songs_object)
    $redis.expire("songs", 10.day.to_i)
  end
end
