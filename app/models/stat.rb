class Stat
  attr_reader :host

  def initialize(args)
    @host = Host.find(args.fetch(:host))
  end

  def total_song_count
    Song.all.size
  end

  def essential
    @host ? Song.where("#{@host.slug}_score >= 90").size : Song.essential.size
  end

  def yacht_rock
    @host ? Song.where("#{@host.slug}_score >= 50 AND #{@host.slug}_score < 90").size : Song.not_essential.yacht_rock.size
  end

  def nyacht_rock
    @host ? Song.where("#{@host.slug}_score < 50").size : Song.nyacht_rock.size
  end

  def weird_essentials
    Song.not_essential.where("#{@host.slug}_score >= 90").order("#{@host.slug}_score desc")
  end

  def deviation_from_mean
    Song.average("#{@host.slug}_score").to_f - Song.average("yachtski")
  end

  def dissents
    query = <<-SQL
      select s.id, (#{@host.slug}_score - ((#{@host.other_hosts[0].slug}_score + #{@host.other_hosts[1].slug}_score + #{@host.other_hosts[2].slug}_score) / 3.0)) as dissent from songs s
      ORDER BY dissent DESC
      SQL
    result = ActiveRecord::Base.connection.execute(query)
    result.as_json
  end

  def disagreements
    all_disagreements = @host.other_hosts.inject([]) do |memo, other_host|
      max_yacht_disagreement = Song.maximum("#{@host.slug}_score - #{other_host.slug}_score")
      yacht_song = Song.where("#{@host.slug}_score - #{other_host.slug}_score = ?", max_yacht_disagreement).first.data
      yacht_song[:disagreement] = max_yacht_disagreement

      max_nyacht_disagreement = Song.maximum("#{other_host.slug}_score - #{@host.slug}_score")
      nyacht_song = Song.where("#{other_host.slug}_score - #{@host.slug}_score = ?", max_nyacht_disagreement).first.data
      nyacht_song["disagreement"] = max_nyacht_disagreement

      memo << {
        other_host: other_host,
        yacht: yacht_song,
        nyacht: nyacht_song
      }
    end
    all_disagreements
  end
end
