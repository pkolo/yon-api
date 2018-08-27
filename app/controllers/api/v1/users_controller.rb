class Api::V1::UsersController < Api::V1::ApiController
  before_action :require_login

  def auth
    render json: { id: current_user.id, token: current_user.token }
  end
end
