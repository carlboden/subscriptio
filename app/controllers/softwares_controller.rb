class SoftwaresController < ApplicationController

	before_action :set_software, only: [ :show, :edit, :update, :destroy]
	
	def index
	  @softwares = Software.all
	end

	def show
	end

	def new
	  @software = Software.new
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

	def software_params
  	  params.require(:software).permit(:name, :url, :demo_url, :category)
    end

	def set_software
	  @software = Software.find(params[:id])
	end


end
