class AddRatedAtToSongRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :song_requests, :rated_at, :datetime
  end
end
