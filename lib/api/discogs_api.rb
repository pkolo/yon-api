class Api::DiscogsApi < Api::ApiBase
  include StringUtilities

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

  def search
    artist = sanitize_string_for_search(@options[:artist])
    q = "type=release&artist=#{artist}&track=#{@options[:title]}&token=#{ENV.fetch("DISCOG_TOKEN")}"
    response = get "https://api.discogs.com/database/search?#{q}"
    response["results"].map {|r| r["id"].to_s}
  end
end
