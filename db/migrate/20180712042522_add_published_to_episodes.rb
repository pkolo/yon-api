class AddPublishedToEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :episodes, :published, :boolean
    add_column :episodes, :date_published, :datetime
  end
end
