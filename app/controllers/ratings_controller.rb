class RatingsController < ApplicationController
	def index
		@ratings = Rating.where(:software_plan_id => params[:software_plan_id])
	end

	def show
		@rating = Rating.find(params[:id])
		@subscription = Subscription.where(:software_plan_id => @rating.software_plan.id)[0]
	end

	def new
	  @softwarePlan = SoftwarePlan.find(params[:software_plan_id])
	  @rating = Rating.new
	end

	def create
	  @rating = Rating.new(rating_params)
	  @softwarePlan = SoftwarePlan.find(params[:software_plan_id])
	  @subscription = Subscription.where(:software_plan_id => params[:software_plan_id])[0]		
  	  @rating.software_plan = @softwarePlan
  	  @rating.user = current_user
  
	  if @rating.save
		
	    redirect_to company_subscriptions_path(current_user.company.id)
	  else
	  	render :new
	  end
	end

	def edit
	end

	def update
	end

	def destroy
	end


	private

	def rating_params
		params.require(:rating).permit(:rating, :description)
	end

end
