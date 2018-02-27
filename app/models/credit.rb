class Credit < ActiveRecord::Base
  before_validation :find_or_initialize_personnel
  after_destroy :destroy_personnel, if: :personnel_is_orphan?

  belongs_to :personnel, touch: true
  belongs_to :creditable, polymorphic: true, optional: true

  accepts_nested_attributes_for :personnel

  validates :role, presence: true
  validates :personnel, presence: true

  def self.role_map(role)
    if role.index(/guitar/i)
      "Guitar"
    elsif role.index(/writ/i)
      "Writing"
    elsif role.index(/produc/i)
      "Producing"
    elsif role.index(/arrange/i)
      "Arranging"
    elsif role.index(/piano/i)
      "Piano"
    elsif role.index(/programm/i)
      "Synth Programming"
    elsif role.index(/synth/i)
      "Synthesizer"
    elsif role == "Artist"
      "Performing Artist"
    elsif role.index(/conduct/i)
      "Conducting"
    elsif role.index(/recorded/i)
      "Engineering"
    elsif role.index(/photog/i)
      "Photography"
    elsif role.index(/keyboard/i)
      "Keyboards"
    elsif role.index(/manage/i)
      "Management"
    else
      role
    end

  end

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
        self.personnel = Personnel.create(name: self.personnel.name, discog_id: self.personnel.discog_id)
      end
    end

    def personnel_is_orphan?
      self.personnel.credits.empty?
    end

    def destroy_personnel
      self.personnel.destroy
    end

end
