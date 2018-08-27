class Episode < ActiveRecord::Base
  has_and_belongs_to_many :songs
  belongs_to :show

  before_validation :set_defaults
  after_update :set_date_published

  validates :number, presence: true, uniqueness: true

  private

  def set_defaults
    self.published = false
    self.number = "#{self.show.abbreviation}#{self.episode_no}"
  end

  def set_date_published
    self.date_published = DateTime.current if published
  end
end
