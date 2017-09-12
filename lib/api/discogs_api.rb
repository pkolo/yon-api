class Api::DiscogsApi < Api::ApiBase
  attr_accessor :type, :id

  def initialize(args)
    @type = args.fetch :type, nil
    @id = args.fetch :id, nil
    @options = args.fetch :options, nil
  end

  def url
    "https://api.discogs.com/#{@type}s/#{@id}"
  end

  def get_data
    get url
  end
end
