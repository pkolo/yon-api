class CreateSongsEpisodes < ActiveRecord::Migration[5.1]
def change
    create_join_table :songs, :episodes
  end
end
