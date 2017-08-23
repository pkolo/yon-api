class Personnel < ActiveRecord::Base
  has_many :credits

  has_many :songs, -> { distinct }, through: :credits, source: :creditable, source_type: 'Song'
  has_many :albums, -> { distinct }, through: :credits, source: :creditable, source_type: 'Album'

  has_many :songs_as_performer, ->(credit) { where 'credits.role = ?', "Artist" }, through: :credits, source: :creditable, source_type: 'Song'
  has_many :albums_as_performer, ->(credit) { where 'credits.role = ?', "Artist" }, through: :credits, source: :creditable, source_type: 'Album'
end
