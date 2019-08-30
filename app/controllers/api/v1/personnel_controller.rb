class Api::V1::PersonnelController < ApplicationController
  def show
    @personnel = Personnel.find(params[:id])
    render json: PersonnelSerializer.render(@personnel, view: :extended)
  end

  def search
    @personnel = Personnel.name_search(params[:q])
    render json: PersonnelSerializer.render(@personnel, view: :extended)
  end
end
