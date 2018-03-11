class AddShowDataToEpisode < ActiveRecord::Migration[5.1]
  def change
    Episode.all.each do |episode|
      abbreviation = episode.number[0..2]
      episode_number = episode.number[3..-1]
      show = Show.find_by(abbreviation: abbreviation)

      episode.update_columns(episode_no: episode_number, show_id: show.id)
    end
  end
end
