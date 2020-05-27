class RatingsController < ApplicationController
	#t.integer "rating"
    #t.text "description"
    #t.bigint "user_id", null: false
    #t.bigint "software_plan_id", null: false


    def index
	  @ratings = Rating.where(:software_plan_id => params[:id])
	end

	def show

	end

	def new
	  @softwarePlan = SoftwarePlan.find(params[:software_plan_id])
	  @rating = Rating.new
	end

	def create
	  @rating = Rating.new(rating_params)
  	  @softwarePlan = SoftwarePlan.find(params[:software_plan_id])
  	  @rating.software_plan = @softwarePlan
  	  @rating.user = current_user

	  
	  if @rating.save
	    redirect_to software_plan_path(@softwarePlan)
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
