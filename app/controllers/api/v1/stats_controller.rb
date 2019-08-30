class Api::V1::StatsController < Api::V1::ApiController
  def show
    @stat = Stat.new({host: params[:id]})
    render json: HostStatSerializer.render(@stat)
  end
end
