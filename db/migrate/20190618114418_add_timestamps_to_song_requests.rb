class AddTimestampsToSongRequests < ActiveRecord::Migration[5.1]
  def change
    add_timestamps(:song_requests, null: false)
  end
end
