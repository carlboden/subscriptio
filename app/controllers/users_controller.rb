class UsersController < ApplicationController

    def show
        @user = User.find(current_user.id)
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(current_user.id)
        @user.update(user_params)
        redirect_to user_path(current_user.id)
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


