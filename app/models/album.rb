class Album < ActiveRecord::Base
  has_many :songs
  has_many :credits, as: :creditable, dependent: :destroy
end
