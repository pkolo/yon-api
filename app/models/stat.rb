class Stat
  attr_reader :host

  def initialize(args)
    @host = Host.new(args.fetch(:host))
  end

  def total_song_count
    Song.all.size
  end

  def essential
    @host ? Song.where("#{@host.name}_score >= 90") : Song.essential
  end

  def yacht_rock
    @host ? Song.where("#{@host.name}_score >= 50 AND #{@host.name}_score < 90") : Song.not_essential.yacht_rock
  end

  def nyacht_rock
    @host ? Song.where("#{@host.name}_score < 50") : Song.nyacht_rock
  end

  def weird_essentials
    Song.not_essential.where("#{@host.name}_score >= 90")
  end

  def deviation_from_mean
    Song.average("#{@host.name}_score").to_f - Song.average("yachtski")
  end

  def dissents
    query = <<-SQL
      select s.id, (#{@host.name}_score - ((#{@host.other_hosts[0]}_score + #{@host.other_hosts[1]}_score + #{@host.other_hosts[2]}_score) / 3.0)) as dissent from songs s
      ORDER BY dissent DESC
      SQL
    result = ActiveRecord::Base.connection.execute(query)
    result.as_json
  end

  def disagreements
    @host.other_hosts.each_with_object({}) do |other_host, memo|
      max_yacht_disagreement = Song.maximum("#{@host.name}_score - #{other_host}_score")
      yacht_song = Song.where("#{@host.name}_score - #{other_host}_score = ?", max_yacht_disagreement).first.data
      yacht_song[:disagreement] = max_yacht_disagreement

      max_nyacht_disagreement = Song.maximum("#{other_host}_score - #{@host.name}_score")
      nyacht_song = Song.where("#{other_host}_score - #{@host.name}_score = ?", max_nyacht_disagreement).first.data
      nyacht_song["disagreement"] = max_nyacht_disagreement

      memo[other_host] = {
        yacht: yacht_song,
        nyacht_song: nyacht_song
      }
    end
  end
end
