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
	  @softwarePlan = SoftwarePlan.find(params[:software_plan_id])
	  @softwareFeature.software_plan = @softwarePlan
	  @feature = Feature.find(params[:software_feature][:feature_id])
      @softwareFeature.feature = @feature
	  if @softwareFeature.save
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
	  @softwareFeature = SoftwareFeature.find(params[:id])
	  @softwarePlan = @softwareFeature.software_plan
	  @softwareFeature.delete
	  redirect_to software_plan_path(@softwarePlan)

	end


	private


	def set_softwareFeature
	  @softwareFeature = SoftwareFeature.find(params[:id])
	end

end
