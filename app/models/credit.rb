class Credit < ActiveRecord::Base
  before_validation :find_or_initialize_personnel

  belongs_to :personnel
  belongs_to :creditable, polymorphic: true, optional: true

  accepts_nested_attributes_for :personnel

  validates :role, presence: true
  validates :personnel, presence: true

  def find_or_initialize_personnel
    # Find or initialize the personnel by name
    self.personnel = Personnel.find_or_initialize_by(name: self.personnel.name)
  end

end
