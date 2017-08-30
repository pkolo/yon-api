class Api::V1::AlbumsController < ApplicationController

  def show
    @album = Album.find(params[:id])
    render json: @album, serializer: ExtendedAlbumSerializer
  end

end
