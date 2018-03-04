class Host
  attr_reader :slug, :full_name

  def initialize(slug, full_name)
    @slug = slug
    @full_name = full_name
  end

  HOST_NAMES = %w(jd hunter steve dave).map(&:freeze).freeze
  JD     = new("jd", "JD Ryznar")
  HUNTER = new("hunter", "Hunter Stair")
  STEVE  = new("steve", "Steve Huey")
  DAVE   = new("dave", "Dave Lyons")

  def self.all
    [JD, HUNTER, STEVE, DAVE]
  end

  def self.find(slug)
    self.all.find { |host| host.slug == slug }
  end

  def other_hosts
    Host.all.select {|host| host != self}
  end
end
