class Api::V1::StatsController < Api::V1::ApiController
  def show
    @stat = Stat.new({host: params[:id]})
    render json: @stat, serializer: HostStatSerializer, status: :ok
  end
end
