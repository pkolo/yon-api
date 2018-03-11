class AddDateAndTitleToEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :episodes, :air_date, :date
    add_column :episodes, :title, :string
  end
end
