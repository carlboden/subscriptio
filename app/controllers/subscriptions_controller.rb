class SubscriptionsController < ApplicationController

  def index

        @subscriptions = Subscription.where(:company_id => params[:company_id])

        @lowest_price_same_range_number_user = calculate_cheaper_plan_range_user(@subscriptions)

        @all_alternative_hash = calculate_alternative_price(@subscriptions)
        
        if params[:query2].present?
          @subscriptions = Subscription.where(:software_plan_id => SoftwarePlan.where(software_id: Software.where("name ILIKE ?", "%#{params[:query2]}%")), :company_id => params[:company_id])
          array_subscription_in_scope = []
          @subscriptions.each do |subscription|
            array_subscription_in_scope << subscription.id
          end
          @lowest_price_same_range_number_user = @lowest_price_same_range_number_user.select{|key, content| array_subscription_in_scope.include? key}
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
      
      @subscription = Subscription.find(params[:id])
      create_data_histogram
      subscription_array = [@subscription]
      @all_alternative_hash = calculate_alternative_price(subscription_array)

      

      same_software_lowest_price_market

      same_software_lowest_price_same_users

      

      other_software_better_reviews

      # Did user already do review of this software plan?
      @subscription.software_plan.ratings.each do |rating|
        if rating.user_id == current_user.id
          @reviewed = true
        end
      end

      #Average rating
      sum = 0.0
      @average_review = 0.0
      @subscription.software_plan.ratings.each do |rating|
        if rating.rating != nil
            sum += rating.rating
        end
      end

      if sum != 0.0
        @average_review = (sum / @subscription.software_plan.ratings.length).round(2)
      end

      @rating = Rating.new  

    end


    private


    def strip_date(date)
      format_date = date.strftime('%Y%m')
      # To keep the format the same even if for the first date
      # formatted_date = format_date[0..3] + ( format_date[4..7].to_i).to_s

  end

  def add_one_day_strip_date(date)
      if date[4..7].to_i == 12
          (date[0..3].to_i + 1).to_s + "1"
      else
          date[0..3] + ( date[4..7].to_i + 1).to_s
      end

  end


  def calculate_alternative_price(subscriptions)
    all_alternative_hash = {}

    subscriptions.each do |sub|
      alt_soft = Software.includes(:subscriptions, software_plans: :features).where( category: sub.software.category).where.not(id: sub.software.id)
      alt_plans = (alt_soft).map(&:software_plans).flatten.select do |soft|
         (sub.software_plan.features | soft.features).size > sub.software_plan.features.size / 2 
      end 
    
      compares_subscriptions = alt_plans.map(&:subscriptions).flatten

      lowest_price_same_features = calculate_cheaper_plan_range_user(compares_subscriptions)
      lowest_price = {sub.id => [0, 15000000]}
      lowest_price_same_features.each do |key, subscription_same_feature|
        if lowest_price.values[0][1] > subscription_same_feature[0].price
          lowest_price = {sub.id =>[key, subscription_same_feature[0].price] }
        end
      end

      all_alternative_hash = all_alternative_hash.merge(lowest_price)
    end
    all_alternative_hash
  end

  def calculate_cheaper_plan_range_user(subscriptions)
    lowest_price_same_range_number_user = {}
    red_light_price = {}
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

      subscription_in_range.each do |key, subscriptio|
        if subscription_in_range[key][0].price < subscription.price
          red_light_price[key] = [subscription_in_range[key][0], subscription]
        else
          lowest_price_same_range_number_user[key] = [subscription_in_range[key][0], subscription]
        end
      end
    end
    lowest_price_same_range_number_user = red_light_price.merge(lowest_price_same_range_number_user)
    
  end


  def create_data_histogram

    @expenses_per_month = {"2020-01" => 0, "2020-02" => 0, "2020-03" => 0, "2020-04" => 0, "2020-05" => 0, "2020-06" => 0, "2020-07" => 0, "2020-08" => 0, "2020-09" => 0, "2020-10" => 0, "2020-11" => 0, "2020-12" => 0}
      @low_expenses_per_month = {"2020-01" => 0, "2020-02" => 0, "2020-03" => 0, "2020-04" => 0, "2020-05" => 0, "2020-06" => 0, "2020-07" => 0, "2020-08" => 0, "2020-09" => 0, "2020-10" => 0, "2020-11" => 0, "2020-12" => 0}
      @sum_expenses = 0
      @low_sum_expenses = 0
      @subscription_status = {"You already have the best plan" => 0, "Cheaper Plan Available" => 0}
      @subscription_range_price = {"0 - 25€" => 0, "26 - 50€" => 0, "51 - 100€" => 0, "101 - 250€" => 0, "251 - 500€" => 0, "501€ +" => 0}
      @sum_expenses = 0
      @low_sum_expenses = 0
      subscriptions = Subscription.order(:start_date).where(:software_plan_id => @subscription.software_plan_id)
      subscriptions.each do |subscription|
        subscription_in_range = []
        subscription_decreasing_order = Subscription.order('price ASC').where(:software_plan_id => @subscription.software_plan_id)
        range_user = (subscription.number_of_user - (1 + (subscription.number_of_user/2)**2))..(subscription.number_of_user + (1 + (subscription.number_of_user/2)**2))
        subscription_decreasing_order.each do |subscription|
            if range_user === subscription.number_of_user
                subscription_in_range << subscription
            end
        end

        subscription.price == subscription_in_range[0].price ? @subscription_status["You already have the best plan"] += 1 : @subscription_status["Cheaper Plan Available"] += 1
        if (0..25) === ( subscription.price  * subscription.number_of_user )
        @subscription_range_price["0 - 25€"] += 1
        elsif (26..50) === ( subscription.price  * subscription.number_of_user )
        @subscription_range_price["26 - 50€"] += 1
        elsif (51..100) === ( subscription.price  * subscription.number_of_user )
        @subscription_range_price["51 - 100€"] += 1
        elsif (101..250) === ( subscription.price  * subscription.number_of_user )
        @subscription_range_price["101 - 250€"] += 1
        elsif (251..500) === ( subscription.price  * subscription.number_of_user )
        @subscription_range_price["251 - 500€"] += 1
        else
        @subscription_range_price["501€ +"] += 1
        end


        start_date = strip_date(subscription.start_date)
        end_date = strip_date(subscription.end_date)

        # To have if the month is before 10, keep the format 2020-05
        udpate_format_date = start_date[0..3] + '-' + ( start_date[4..7].to_i < 10 ?  "0" + start_date[4..7].to_i.to_s : start_date[4..7])
        if @expenses_per_month[udpate_format_date] == nil

            @expenses_per_month[udpate_format_date] = ( subscription.price * subscription.number_of_user )
            @low_expenses_per_month[udpate_format_date] = ( subscription_in_range[0].price * subscription.number_of_user )
            @sum_expenses += ( subscription.price * subscription.number_of_user )
            @low_sum_expenses += ( subscription_in_range[0].price * subscription.number_of_user )
        else
            @expenses_per_month[udpate_format_date] += ( subscription.price * subscription.number_of_user )
            @low_expenses_per_month[udpate_format_date] += ( subscription_in_range[0].price * subscription.number_of_user )
            @sum_expenses += ( subscription.price * subscription.number_of_user )
            @low_sum_expenses += ( subscription_in_range[0].price * subscription.number_of_user )
        end

        start_date = add_one_day_strip_date(start_date)

        while start_date.to_i <= end_date.to_i
            udpate_format_date = start_date[0..3] + '-' + ( start_date[4..7].to_i < 10 ? "0" + start_date[4..7] : start_date[4..7] )
            if @expenses_per_month[udpate_format_date] == nil
                @expenses_per_month[udpate_format_date] = ( subscription.price * subscription.number_of_user )
                @low_expenses_per_month[udpate_format_date] = ( subscription_in_range[0].price * subscription.number_of_user )
                @sum_expenses += ( subscription.price * subscription.number_of_user )
                @low_sum_expenses += ( subscription_in_range[0].price * subscription.number_of_user )
            else
                @expenses_per_month[udpate_format_date] += ( subscription.price * subscription.number_of_user )
                @low_expenses_per_month[udpate_format_date] += ( subscription_in_range[0].price * subscription.number_of_user )
                @sum_expenses += ( subscription.price * subscription.number_of_user )
                @low_sum_expenses += ( subscription_in_range[0].price * subscription.number_of_user )
            end
            start_date = add_one_day_strip_date(start_date)

        end
    end
  end


    def params_subscription
        params.require(:subscription).permit(:start_date, :end_date, :price, :software_plan_id, :number_of_user)
    end

    def same_software_lowest_price_market
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

                end
              software_plan_with_ratings[plan.id] = sum / (ratings_plan.length)
              @average_review = software_plan_with_ratings[plan.id].round(2)
            else
              software_plan_with_ratings[plan.id] = 0
            end
          end
        end
        
        @max_rating = software_plan_with_ratings[all_software_plans[0][0].id]
        max_rating_id = all_software_plans[0][0].id
        software_plan_with_ratings.each do |key, index|
          if @max_rating < index
            max_rating_id = key
            @max_rating = index
          end
        end

        @max_rated_alternative = SoftwarePlan.find(max_rating_id)
  
    end

end
