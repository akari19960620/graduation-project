class FacilitiesController < ApplicationController
  skip_before_action :require_login, only: [ :show ]

  def show
    @facility = Facility.find(params[:id])
    @diagnosis = Diagnosis.find(params[:diagnosis_id]) if params[:diagnosis_id].present?
  end
end
