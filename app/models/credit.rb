class Credit < ActiveRecord::Base
  before_validation :find_or_initialize_personnel
  after_destroy :destroy_personnel, if: :personnel_is_orphan?

  belongs_to :personnel, touch: true
  belongs_to :creditable, polymorphic: true, optional: true

  accepts_nested_attributes_for :personnel

  validates :role, presence: true
  validates :personnel, presence: true

  private

    def find_or_initialize_personnel
      # Find or initialize the personnel by name
      existing_personnel = Personnel.find_by(name: self.personnel.name)
      if existing_personnel && existing_personnel.has_discog?
        self.personnel = existing_personnel
      elsif existing_personnel
        existing_personnel.update(discog_id: self.personnel.discog_id)
        self.personnel = existing_personnel
      else
        self.personnel = Personnel.new(name: self.personnel.name, discog_id: self.personnel.discog_id)
      end
    end

    def personnel_is_orphan?
      self.personnel.credits.empty?
    end

    def destroy_personnel
      self.personnel.destroy
    end

end
