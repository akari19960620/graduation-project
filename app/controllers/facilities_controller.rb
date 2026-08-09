class FacilitiesController < ApplicationController
  def show
    @facility = Facility.find(params[:id])
    @diagnosis = Diagnosis.find(params[:diagnosis_id]) if params[:diagnosis_id].present?
  end
end
