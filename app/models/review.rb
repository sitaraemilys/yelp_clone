class Review < ActiveRecord::Base

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.reviews.create(review_params)
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

end
