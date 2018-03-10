class Episode < ActiveRecord::Base
  has_and_belongs_to_many :songs

  validates :number, presence: true, uniqueness: true
end
