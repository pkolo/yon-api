class AddDataIdToEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :episodes, :data_id, :string
  end
end
