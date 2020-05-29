class SubscriptionsController < ApplicationController
    def index
        @subscriptions = Subscription.all
        @subscription_decreasing_order = Subscription.order('price ASC').all
    end 

    def new
        @company = Company.find(current_user.company_id)
        @softwares = Software.order('name ASC').all   
        @subscription = Subscription.new
    end

    def create
        @subscription = Subscription.new(params_subscription)
        @company = Company.find(current_user.company_id)
        @subscription.company = @company
        if @subscription.save
            redirect_to company_subscriptions_path(@company.id)
        else
            render :new
        end
    end

    def edit
        @company = Company.find(current_user.company_id)
        @softwares = Software.order('name ASC').all   
        @subscription = Subscription.find(params[:id])
    end

    def update
        @subscription = Subscription.find(params[:id])
        @company = Company.find(current_user.company_id)
        @subscription.update(params_subscription)
        redirect_to company_subscriptions_path(@company.id)
    end

    def destroy
        @subscription = Subscription.find(params[:id])
        @subscription.destroy
        @company = Company.find(current_user.company_id)
        redirect_to company_subscriptions_path(@company.id)
    end

    def show
        @subscription = Subscription.find(params[:id])
        @subscription_decreasing_order = Subscription.order('price ASC').all
    end

    private

    def params_subscription
        params.require(:subscription).permit(:start_date, :end_date, :price, :software_plan_id)
    end
end
