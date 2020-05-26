class SoftwarePlansController < ApplicationController

	def index
	  @softwarePlans = SoftwarePlan.where(:software_id => params[:software_id])
	  @software = Software.find(params[:software_id])
	end

	def show
	  @softwarePlan = SoftwarePlan.find(params[:id])
	  @softwareFeatures = SoftwareFeature.where(:software_plan_id => params[:id])
	end

	def new
	  @softwarePlan = SoftwarePlan.new
	  @software = Software.find(params[:software_id])
	end

	def create
	  @softwarePlan = SoftwarePlan.new(softwareplan_params)
	  @software = Software.find(params[:software_id])
	  @softwarePlan.software = @software

	  if @softwarePlan.save
	    redirect_to software_software_plans_path(@software)
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

	def softwareplan_params
  	  params.require(:software_plan).permit(:name, :official_price)
    end

	def set_softwarePlan
	  @softwarePlan = SoftwarePlan.find(params[:id])
	end

end
