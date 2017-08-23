class Song < ActiveRecord::Base
  belongs_to :album
  has_many :credits, as: :creditable, dependent: :destroy
end
