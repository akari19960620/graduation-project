class FavoritesController < ApplicationController
  def index
    @favorites = current_user.favorites.includes(:facility)
  end

  def create
    facility = Facility.find(params[:facility_id])
    current_user.favorites.create(facility: facility)
    redirect_to facility_path(facility)
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    favorite.destroy
    # request.refererとは、どのページから今のリクエストが送られてきたかを表すURL
    # request.refererが存在すればそれを使う、存在しなければ(nilの場合)favorites_pathを使う
    redirect_to(request.referer || favorites_path)
  end
end
