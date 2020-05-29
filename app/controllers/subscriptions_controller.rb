class SubscriptionsController < ApplicationController
    def index
        #@softwares = Software.pluck(:name).sort
        @subscriptions = Subscription.where(:company_id => params[:company_id])
        @subscription_decreasing_order = Subscription.order('price ASC').where(:company_id => params[:company_id])

        if params[:query].present?
          PgSearch::Multisearch.rebuild(Feature)
          PgSearch::Multisearch.rebuild(Software)
          @results = PgSearch.multisearch(params[:query])
          #@results = Feature.whose_name_starts_with(params[:query])
        else
         @softwares = Software.all
        end

        if params[:query2].present?
          @subs = []
          @subscriptions.each do |sub|
            @subs << sub if params[:query2] == sub.software_plan.software.name
          end
        else
          @subs = @subscriptions
        end

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
        @subscription_decreasing_order = Subscription.order('price ASC').where(:software_plan_id => @subscription.software_plan_id)
        @lowest_price = @subscription_decreasing_order[0]
        @subscription_in_range = []
        range_user = (@subscription.number_of_user - (1 + (@subscription.number_of_user/2)**2))..(@subscription.number_of_user + (1 + (@subscription.number_of_user/2)**2))
        @subscription_decreasing_order.each do |subscription|
            if range_user === subscription.number_of_user
                @subscription_in_range << subscription
            end
        end
        @lowest_price_same_range_number_user = @subscription_in_range[0]
    end

    private

    def params_subscription
        params.require(:subscription).permit(:start_date, :end_date, :price, :software_plan_id, :number_of_user)
    end
end
