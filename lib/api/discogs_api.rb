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
    title = sanitize_string_for_search(@options[:title])
    q = "type=release&artist=#{artist}&track=#{title}&token=#{ENV.fetch("DISCOG_TOKEN")}"

    response = get "https://api.discogs.com/database/search?#{q}"

    if response["results"].empty?
      q = "type=release&credit=#{artist}&track=#{title}&token=#{ENV.fetch("DISCOG_TOKEN")}"

      response = get "https://api.discogs.com/database/search?#{q}"
    end

    response["results"].sort_by {|r| r["community"]["have"]}.reverse
  end
end
