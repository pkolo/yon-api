class Api::V1::ShowsController < Api::V1::ApiController
  # before_action :require_login, only: [:index]

  def index
    render json: Show.all, adapter: false
  end
end
