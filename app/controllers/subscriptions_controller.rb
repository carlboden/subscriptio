class SubscriptionsController < ApplicationController
  
  def index
        #@softwares = Software.pluck(:name).sort
        @subscriptions = Subscription.where(:company_id => params[:company_id])
        @lowest_price_same_range_number_user = calculate_cheaper_plan_range_user(@subscriptions)
        @all_alternative_hash = calculate_alternative_price(@subscriptions)




        

        if params[:query2].present? 
          @subscriptions = Subscription.where(:software_plan_id => SoftwarePlan.where(software_id: Software.where("name ILIKE ?", "%#{params[:query2]}%")), :company_id => params[:company_id])
        end
    end

    def new
        @company = Company.find(current_user.company_id)
        @softwares = Software.order('LOWER(name) ASC').all
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

        same_software_lowest_price_market

        same_software_lowest_price_same_users

        other_software_lowest_price

        other_software_better_reviews

        @rating = Rating.new

        @chart = fusion_chart
    end
    

    private



    def calculate_alternative_price(subscriptions)

      all_alternative_hash = {}
      hash_features_all_subscriptions = {}
      subscriptions.each do |subscription|
        features = subscription.software_plan.software_features
        hash_features_all_subscriptions[subscription.id] = []
        features.each {|feature| hash_features_all_subscriptions[subscription.id] << feature.feature_id}
      end

    
      hash_features_all_subscriptions.each do |subscription_id, array_feature|
        sub = Subscription.find(subscription_id)
        alternatives_software_same_category = Software.where(:category => sub.software_plan.software.category)
        alternative_software_plan_same_category = []

        alternatives_software_same_category.each do |alternative|
          plans = SoftwarePlan.where(:software_id => alternative.id)
          plans.each {|plan| alternative_software_plan_same_category << plan}
        end
        features_all_software_plan_hash = {}
        alternative_software_plan_same_category.each do |plan|
          all_features_plan = plan.software_features
          features_all_software_plan_hash[all_features_plan[0].software_plan_id] = []
          all_features_plan.each {|feature| features_all_software_plan_hash[all_features_plan[0].software_plan_id] << feature.feature_id}
        end

        array_same_feature_software_plan = []
        
        features_all_software_plan_hash.each do |key, features|
          right = {true: 0, false: 0}
          array_feature.sample(10).each do |feature|
            if features.include? feature
              right[:true] += 1
            else
              right[:false] += 1
            end
          
          end

          right[:false] < 5 ? array_same_feature_software_plan << key : ""
        
        end

        
        
        subscriptions_same_features = Subscription.where(:software_plan_id =>  array_same_feature_software_plan)

        lowest_price_same_features = calculate_cheaper_plan_range_user(subscriptions_same_features)
        lowest_price = {subscription_id => [0, 1500]}
        lowest_price_same_features.each do |key, subscription|
          if lowest_price.values[0][1] > subscription.price
            lowest_price = {subscription_id =>[key, subscription.price] }
          end
        end
        
        all_alternative_hash = all_alternative_hash.merge(lowest_price)
      
      end
      all_alternative_hash
    end



    def calculate_cheaper_plan_range_user(subscriptions)
      lowest_price_same_range_number_user = {}
      subscriptions.each do |subscription|
        subscription_decreasing_order = Subscription.order('price ASC').where(:software_plan_id => subscription.software_plan_id)
        subscription_in_range = {}
        subscription_in_range[subscription.id] = []
        range_user = (subscription.number_of_user - (1 + (subscription.number_of_user/2)**2))..(subscription.number_of_user + (1 + (subscription.number_of_user/2)**2))
        subscription_decreasing_order.each do |sub|
            if range_user === sub.number_of_user
                subscription_in_range[subscription.id] << sub
            end
        end
  
        subscription_in_range.each do |key, subscription|
          lowest_price_same_range_number_user[key] = subscription_in_range[key][0]
        end
      end
      lowest_price_same_range_number_user
    end


    def params_subscription
        params.require(:subscription).permit(:start_date, :end_date, :price, :software_plan_id, :number_of_user)
    end

    def same_software_lowest_price_market
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
    end

    def same_software_lowest_price_same_users
      @subscription = Subscription.find(params[:id])
        range_user = (@subscription.number_of_user - (1 + (@subscription.number_of_user/2)**2))..(@subscription.number_of_user + (1 + (@subscription.number_of_user/2)**2))

        @lowest_price_same_range_number_user = @subscription_in_range[0]
        @softwares_same_category = Software.where(:category => @subscription.software_plan.software.category)
        all_software_plans = []
        @softwares_same_category.each { |software| all_software_plans << software.software_plans}
        all_subscription = []
        all_software_plans.each do |software|
          software.each do |plan|
            Subscription.where(software_plan_id: plan.id,  :number_of_user => range_user ).order("price ASC")[0] != nil ? all_subscription << Subscription.where(software_plan_id: plan.id).order("price ASC")[0] : ""
          end
        end
    end


    def other_software_lowest_price
       @subscription = Subscription.find(params[:id])
       range_user = (@subscription.number_of_user - (1 + (@subscription.number_of_user/2)**2))..(@subscription.number_of_user + (1 + (@subscription.number_of_user/2)**2))

        @softwares_same_category = Software.where(:category => @subscription.software_plan.software.category)
        all_software_plans = []
        @softwares_same_category.each { |software| all_software_plans << software.software_plans}
        all_subscription = []
        all_software_plans.each do |software|
          software.each do |plan|
            Subscription.where(software_plan_id: plan.id,  :number_of_user => range_user ).order("price ASC")[0] != nil ? all_subscription << Subscription.where(software_plan_id: plan.id).order("price ASC")[0] : ""
          end
        end

      min_price = all_subscription[0].price
        @lowest_subscription = all_subscription[0]
        all_subscription.each do |subscription|
          if min_price > subscription.price
            min_price = subscription.price
            @lowest_subscription = subscription
          end
        end
    end

    def other_software_better_reviews
      all_software_plans = []
      @softwares_same_category.each { |software| all_software_plans << software.software_plans}

      software_plan_with_ratings = {}
        all_software_plans.each do |software|

          software.each do |plan|
            sum = 0.0
            if Rating.where(software_plan_id: plan.id)[0] != nil

              ratings_plan = Rating.where(software_plan_id: plan.id)

                ratings_plan.each do |rating|
                  if rating.rating != nil
                    sum += rating.rating
                  end
                  if rating.user_id = current_user.id
                    @reviewed = true
                  end
                end
              software_plan_with_ratings[plan.id] = sum / (ratings_plan.length)
              @average_review = software_plan_with_ratings[plan.id].round(2)
            else
              software_plan_with_ratings[plan.id] = 0
            end
          end
        end

        max_rating = software_plan_with_ratings[all_software_plans[0][0].id]
        max_rating_id = all_software_plans[0][0].id
        software_plan_with_ratings.each do |key, index|
          if max_rating < index
            max_rating_id = key
          end
        end
        @max_rated_alternative = SoftwarePlan.find(max_rating_id)

    end

    def fusion_chart
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

end
