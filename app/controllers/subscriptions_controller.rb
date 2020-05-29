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
          @subs= Subscription.software_search(params[:query2])
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
        @rating = Rating.new
        @softwarePlan = SoftwarePlan.where(:subscription_id => params[:id])

        @chart =
      Fusioncharts::Chart.new(
        {
          width: '600',
          height: '400',
          type: 'boxandwhisker2d',
          renderAt: 'chartContainer',
          dataSource: {
            :"chart" => {
              :"caption" => 'Annual Retail Industry Sales Distribution for US',
              :"subcaption" => '2010-2016',
              :"yaxisname" => 'Sales (in million $)',
              :"yaxismaxvalue" => '28000',
              :"palettecolors" => '#5D62B5, #979AD0',
              :"yaxisminvalue" => '9000',
              :"theme" => 'fusion',
              :"showlegend" => '0',
              :"plotspacepercent" => '55',
              :"showalloutliers" => '1',
              :"outliericonsides" => '20',
              :"outliericonalpha" => '40',
              :"outliericonshape" => 'triangle',
              :"outliericonradius" => '4',
              :"mediancolor" => '#FFFFFF',
              :"plottooltext" =>
                '<b>Sales for $label:</b><br>Max: <b>$maxDataValue million</b><br>Q3: <b>$Q3 million</b><br>Median: <b>$median million</b><br>Q1: <b>$Q1 million</b><br>Min: <b>$minDataValue million</b>'
            },
            :"categories" => [
              {
                :"category" => [
                  { :"label" => '2010' },
                  { :"label" => '2011' },
                  { :"label" => '2012' },
                  { :"label" => '2013' },
                  { :"label" => '2014' },
                  { :"label" => '2015' },
                  { :"label" => '2016' }
                ]
              }
            ],
            :"dataset" => [
              {
                :"seriesname" => 'US',
                :"data" => [
                  {
                    :"value" =>
                      '12297, 12819, 14632, 14184, 14922, 14273, 13955, 14709, 13520, 14387',
                    :"outliers" => '18415, 26642'
                  },
                  {
                    :"value" =>
                      '12857, 14178, 14513, 14485, 14719, 13901, 14675, 13597, 14263',
                    :"outliers" => '11895, 18035, 26243'
                  },
                  {
                    :"value" =>
                      '11428, 13165, 14445, 13576, 14108, 13908, 13145, 14710, 13124, 13485',
                    :"outliers" => '17615, 24604'
                  },
                  {
                    :"value" =>
                      '11313, 12047, 13927, 12474, 13944, 13251, 12594, 14139, 12500, 13309',
                    :"outliers" => '16882, 23814'
                  },
                  {
                    :"value" =>
                      '10579, 11583, 13223, 13055, 13970, 12957, 12670, 14113, 12111, 13150, 16804',
                    :"outliers" => '23853'
                  },
                  {
                    :"value" =>
                      '10797, 11231, 13178, 12349, 13692, 12561, 12555, 13653, 12023, 12936',
                    :"outliers" => '16301, 23425'
                  },
                  {
                    :"value" =>
                      '10221, 11208, 12648, 11925, 12536, 12308, 11836, 12628, 11355, 11945',
                    :"outliers" => '17473, 23962'
                  }
                ]
              }
            ]
          }
        }
      )
    end

    private

    def params_subscription
        params.require(:subscription).permit(:start_date, :end_date, :price, :software_plan_id, :number_of_user)
    end
end
