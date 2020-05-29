class CompaniesController < ApplicationController

    def new
        @company = Company.new
    end

    def create
        @company = Company.new(params_company)
        @company.subscriptio_plan_id = 1
        @user = User.find(current_user.id)
        @user.company_admin = true
        if @company.save
            @user.company_id = @company.id
            @user.save
            redirect_to root_path
        else
            render :new
        end
    end

    def show
        @company = Company.find(current_user.company_id)
        @users = User.where(:company_id => params[:company_id])
    end

    private

    def params_company
        params.require(:company).permit(:name, :address, :country, :company_size, :turnover)
    end
end
