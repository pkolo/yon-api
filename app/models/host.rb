class Host
  attr_reader :name
  
  def initialize(name)
    @name = name
  end

  HOST_NAMES = %w(jd hunter steve dave).map(&:freeze).freeze

  def self.all
    HOST_NAMES
  end

  def other_hosts
    HOST_NAMES - [@name]
  end
end
