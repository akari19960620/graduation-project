class FavoritesController < ApplicationController
  def create
    facility = Facility.find(params[:facility_id])
    current_user.favorites.create(facility: facility)
    redirect_to facility_path(facility)
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    favorite.destroy
    redirect_to facility_path(favorite.facility)
  end
end
