class RemoveEpisodeFromSongs < ActiveRecord::Migration[5.1]
  def change
    remove_column :songs, :episode_id
  end
end
