class FeaturesController < ApplicationController

	before_action :set_feature, only: [:show, :edit, :update, :destroy]
	
	def index
	  @features = Feature.all
	end

	def show
	  @feature = Feature.find(params[:id])
	end

	def new
	  @feature = Feature.new
	end

	def create
	  @feature = Feature.new(feature_params)
	  @feature.save
	  redirect_to features_path
	end

	def edit
	end

	def update
	end

	def destroy
	end


	private

	def feature_params
  	  params.require(:feature).permit(:name)
    end

	def set_feature
	  @feature = Feature.find(params[:id])
	end




end
