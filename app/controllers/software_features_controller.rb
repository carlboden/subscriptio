class SoftwareFeaturesController < ApplicationController
	def index
	  @softwareFeatures = SoftwareFeature.where(:software_plan_id => params[:id])
	end

	def show

	end

	def new
	  @softwarePlan = SoftwarePlan.find(params[:software_plan_id])
	  @softwareFeature = SoftwareFeature.new
	end

	def create
	  @softwareFeature = SoftwareFeature.new
	  @sofwarePlan = SoftwarePlan.find(params[:software_plans_id])
	  @softwareFeature.sofwarePlan = @sofwarePlan
	end

	def edit
	end

	def update
	end

	def destroy
	end


	private


	def set_softwareFeature
	  @softwareFeature = SoftwareFeature.find(params[:id])
	end

end
