class Episode < ActiveRecord::Base
  has_many :songs

  validates :number, presence: true, uniqueness: true
end
