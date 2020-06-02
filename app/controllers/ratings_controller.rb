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
	  @softwarePlan = SoftwarePlan.find(params[:software_plan_id])
	  @subscription = Subscription.where(:software_plan_id => params[:software_plan_id])[0]
    @rating = Rating.new(rating_params)
  	  @rating.software_plan = @softwarePlan
  	  @rating.user = current_user

	  if @rating.save
     redirect_to company_subscription_path(current_user.company.id, @subscription)
	  else
	  	render :new
	  end
	end

    def edit
      @rating = Rating.find(params[:id])
      @softwarePlan = SoftwarePlan.find(params[:software_plan_id])
      @subscription = Subscription.where(:software_plan_id => @rating.software_plan.id)[0]
    end

    def update
        @rating = Rating.find(params[:id])
        @rating.update(rating_params)
        @subscription = Subscription.where(:software_plan_id => params[:software_plan_id])[0]
        redirect_to company_subscription_path(current_user.company.id, @subscription)
    end

    def destroy
        @rating = Rating.find(params[:id])
        @rating.destroy
        @subscription = Subscription.where(:software_plan_id => params[:software_plan_id])[0]
        redirect_to company_subscription_path(current_user.company.id, @subscription)
    end


	private

	def rating_params
		params.require(:rating).permit(:rating, :description)
	end

end
