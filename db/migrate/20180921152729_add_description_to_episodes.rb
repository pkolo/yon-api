class AddDescriptionToEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :episodes, :description, :string
  end
end
