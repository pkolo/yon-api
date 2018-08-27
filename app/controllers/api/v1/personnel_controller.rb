class Api::V1::PersonnelController < ApplicationController
  def show
    @personnel = Personnel.find(params[:id])
    render json: @personnel, serializer: ExtendedPersonnelSerializer
  end

  def search
    @personnel = Personnel.name_search(params[:q])
    render json: @personnel
  end
end
