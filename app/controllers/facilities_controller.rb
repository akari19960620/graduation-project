class FacilitiesController < ApplicationController
  def show
    @facility = Facility.find(params[:id])
  end
end
