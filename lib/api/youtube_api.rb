class Api::YoutubeApi < Api::ApiBase
  include StringUtilities

  def initialize(search_args)
    @root = "https://www.googleapis.com/youtube/v3/search?"
    @q = q_from(search_args)
  end

  def search
    search_params = {part: "snippet",
                     type: "video",
                     videoEmbeddable: true,
                     q: @q,
                     key: ENV['YT_KEY']}
    data = get(@root + parameterize(search_params))
    vid_data = data["items"].first
    vid_data ? vid_data["id"]["videoId"] : ""
  end

  private
    def q_from(song_params)
      "#{sanitize_string_for_search(song_params.values.join(' '))}"
    end
end
