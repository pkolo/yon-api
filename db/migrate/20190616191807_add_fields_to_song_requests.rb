class AddFieldsToSongRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :song_requests, :digested, :boolean, default: false
    add_column :song_requests, :source, :string
  end
end
