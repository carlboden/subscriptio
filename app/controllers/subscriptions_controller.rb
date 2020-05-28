class SubscriptionsController < ApplicationController
    def index
        @subscriptions = Subscription.all
    end 

    def new
        @company = Company.find(current_user.company_id)
        @softwares = Software.all   
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

    private

    def params_subscription
        params.require(:subscription).permit(:start_date, :end_date, :price, :software_plan_id)
    end
end
