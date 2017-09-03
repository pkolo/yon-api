require_relative '../utilities'

class YoutubeApi < ApiBase
  include SearchUtilities

  ROOT = "https://www.googleapis.com/youtube/v3/search?"

  def get_video_id(song_params)
    search_params = {part: "snippet",
                     type: "video",
                     videoEmbeddable: true,
                     q: q_from(song_params),
                     key: ENV['YT_KEY']}
    data = get(ROOT + parameterize(search_params))
    vid_data = data["items"].first
    vid_data["id"]["videoId"]
  end

  private
    def q_from(song_params)
      "#{sanitize_string_for_search(song_params.values.join(' '))}"
    end
end
