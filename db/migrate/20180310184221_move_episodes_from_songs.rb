class MoveEpisodesFromSongs < ActiveRecord::Migration[5.1]
  def change
    Song.all.each do |song|
      sql = "INSERT INTO episodes_songs (song_id, episode_id) VALUES (#{song.id}, #{song.episode.id})"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
