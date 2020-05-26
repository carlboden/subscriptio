class SoftwarePlansController < ApplicationController

	def index
	  @software = Software.find(params[:software_id])
	  @softwarePlans = SoftwarePlan.all
	end

	def show
	  @softwarePlan = SoftwarePlan.find(params[:id])
	end

	def new
	  @softwarePlan = SoftwarePlan.new
	end

	def create
	  @softwarePlan = SoftwarePlan.new(softwarePlan_params)
	  @softwarePlan.save
	  redirect_to softwarePlans_path
	end

	def edit
	end

	def update
	end

	def destroy
	end


	private

	def softwarePlan_params
  	  params.require(:softwarePlan).permit(:name)
    end

	def set_softwarePlan
	  @softwarePlan = SoftwarePlan.find(params[:id])
	end

end
