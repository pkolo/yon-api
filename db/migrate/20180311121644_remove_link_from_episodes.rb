class RemoveLinkFromEpisodes < ActiveRecord::Migration[5.1]
  def change
    remove_column :episodes, :link
  end
end
