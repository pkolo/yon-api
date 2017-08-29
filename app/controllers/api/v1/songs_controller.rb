class Api::V1::SongsController < ApplicationController
  def index
    @songs = Song.all.order("yachtski DESC")
    render json: @songs
  end

  def show
    @song = Song.find(params[:id])
    render json: @song, extended: true
  end
end
