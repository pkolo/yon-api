class SongRequest < ActiveRecord::Base
  scope :undigested, -> { where(digested: false) }
end
