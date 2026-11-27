class ReviewsController < ApplicationController
  def new
    @facility = Facility.find(params[:facility_id])
    @review = current_user.reviews.new
  end

  def create
    @facility = Facility.find(params[:facility_id])
    @review = current_user.reviews.new(review_params)
    @review.facility = @facility

    if @review.save
      redirect_to facility_reviews_path, success: "口コミを投稿しました"
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def review_params
    params.require(:review).permit(:cost_rating, :medical_rating, :facility_rating, :comment)
  end
end
