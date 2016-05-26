class ReviewsController < ApplicationController

	before_action :authenticate_user!

	def new
		@restaurant = Restaurant.find(params[:restaurant_id])
		@review = Review.new

		if @review.save
			redirect_to restaurants_path
		else
			if @review.errors[:user]
				redirect_to restaurants_path alert: 'You have already reviewed this restaurant'
			else
				render :new
			end
		end
	end

	def create
		@restaurant = Restaurant.find(params[:restaurant_id])
		@restaurant.reviews.create(review_params)
		redirect_to '/restaurants'
	end

	private

	def review_params
		params.require(:review).permit(:thoughts, :rating)
	end

end
