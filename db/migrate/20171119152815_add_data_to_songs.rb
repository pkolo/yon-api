class AddDataToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :data, :jsonb
  end
end
