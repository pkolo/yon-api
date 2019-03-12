class CreateSongRequest < ActiveRecord::Migration[5.1]
  def change
    create_table :song_requests do |t|
      t.string :name
      t.string :title
      t.string :artist
      t.string :link
      t.string :message
    end
  end
end
