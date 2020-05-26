class SoftwareFeaturesController < ApplicationController
	def index
	  @softwareFeatures = SoftwareFeature.where(:software_plans_id => params[:software_plans_id ])
	end

	def show

	end

	def new
	  @sofwarePlan = SoftwarePlan.find(params[:software_plans_id])
	  @softwareFeature = SoftwareFeature.new
	end

	def create
	  
	end

	def edit
	end

	def update
	end

	def destroy
	end


	private

	def softwareplan_params
  	  params.require(:software_plan).permit(:name, :official_price)
    end

	def set_softwarePlan
	  @softwarePlan = SoftwarePlan.find(params[:id])
	end

end
