class AddShowFieldsToEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_reference :episodes, :show, foreign_key: true
    add_column :episodes, :episode_no, :integer
  end
end
