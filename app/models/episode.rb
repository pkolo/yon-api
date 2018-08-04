class Episode < ActiveRecord::Base
  has_and_belongs_to_many :songs
  belongs_to :show

  before_validation :set_defaults

  validates :number, presence: true, uniqueness: true

  private

  def set_defaults
    self.published = false
    self.number = "#{self.show.abbreviation}#{self.episode_no}"
  end
end
