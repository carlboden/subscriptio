class SoftwaresController < ApplicationController

	before_action :set_software, only: [:show, :edit, :update, :destroy]
	
	def index
	   if params[:query].present?
	     @softwares = Software.where("name ILIKE ?", "%#{params[:query]}%")
	   else
	     @softwares = Software.all
	   end
	end

	def show
		@software = Software.find(params[:id])
		@softwarePlans = SoftwarePlan.where(:software_id => params[:id])
	end

	def new
	  @software = Software.new
	end

	def create
	  @software = Software.new(software_params)
	  @software.save
	  redirect_to softwares_path
	end

	def edit
	end

	def update
	end

	def destroy
	end

	def project_params
		params.require(:software).permit(:name, :url, :demo_url, :category, software_plans_attributes: [:id, :name, :official_price, :_destroy])
	  end

	private

	def software_params
  	  params.require(:software).permit(:name, :url, :demo_url, :category)
    end

	def set_software
	  @software = Software.find(params[:id])
	end


end
