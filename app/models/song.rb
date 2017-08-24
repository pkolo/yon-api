class Song < ActiveRecord::Base
  belongs_to :album
  has_many :credits, as: :creditable, dependent: :destroy

  has_many :artists, ->(credit) { where 'credits.role IN (?)', ["Artist"] }, through: :credits, source: :personnel
  has_many :featured_artists, ->(credit) { where 'credits.role IN (?)', ["Featuring", "Duet"] }, through: :credits, source: :personnel
end
