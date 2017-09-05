require_relative '../utilities'

class DiscogsApi < ApiBase
  RELEASE_ROOT = "https://api.discogs.com/releases/"

  def get_release(release_id)
    get(RELEASE_ROOT + release_id)
  end
end
