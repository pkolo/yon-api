class Api::V1::StatsController < Api::V1::ApiController
  def show
    render json: Stat.new({host: params[:id]}), serializer: HostStatSerializer
  end
end
