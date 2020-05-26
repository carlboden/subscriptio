class UsersController < ApplicationController

    def index
        if params[:company_id] != nil
            @users = User.where(:company_id => params[:company_id])
            @company = Company.find(params[:company_id])
        end
    end

    def show
        if params[:company_id] != nil
            @user = User.find(params[:id])
        else
            @user = User.find(current_user.id)
        end
    end

    def edit
        if params[:format] == "Approved"
            @approving = true
        elsif params[:format] == "Join"
            @join = true
        end
    
        @user = User.find(params[:id])
    end

    def update
        if params[:user][:status] == "Approved"
            @user = User.find(params[:id])
            @user.status = params[:user][:status]
            @user.save
            redirect_to company_users_path(current_user.company.id)
        elsif params[:user][:status] == "Remove access"
            @user = User.find(params[:id])
            @user.company = nil
            @user.status = nil
            @user.save
            redirect_to company_users_path(current_user.company.id)
        else
            @user = User.find(current_user.id)
            if @user.company == nil
                @company = Company.where(:name => params[:user][:company_id])[0]
                @user.company = @company
                @user.status = "Waiting for approval"
            end
            @user.update(user_params)
            redirect_to user_path(current_user.id)
        end

    end

    def destroy
        @user = User.find(current_user.id)
        @user.destroy
        redirect_to root_path
    end

    private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :function)
    end
end


