class Episode < ActiveRecord::Base
  has_and_belongs_to_many :songs
  belongs_to :show

  validates :number, presence: true, uniqueness: true
end
