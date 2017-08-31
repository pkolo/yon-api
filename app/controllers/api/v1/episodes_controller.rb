class Api::V1::EpisodesController < ApplicationController
  def show
    @episode = Episode.find(params[:id])
    render json: @episode, serializer: ExtendedEpisodeSerializer
  end
end
