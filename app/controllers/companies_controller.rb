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
        @users = User.where(company_id: @company.id)
        @subscriptions = Subscription.order(:start_date).where(:company_id => params[:id])
        
        @expenses_per_month = {"2020-01" => 0, "2020-02" => 0, "2020-03" => 0, "2020-04" => 0, "2020-05" => 0, "2020-06" => 0, "2020-07" => 0, "2020-08" => 0, "2020-09" => 0, "2020-10" => 0, "2020-11" => 0, "2020-12" => 0}
        @low_expenses_per_month = {"2020-01" => 0, "2020-02" => 0, "2020-03" => 0, "2020-04" => 0, "2020-05" => 0, "2020-06" => 0, "2020-07" => 0, "2020-08" => 0, "2020-09" => 0, "2020-10" => 0, "2020-11" => 0, "2020-12" => 0}
        @sum_expenses = 0
        @low_sum_expenses = 0
        @subscription_status = {"You already have the best plan" => 0, "Cheaper Plan Available" => 0}
        @subscription_range_price = {"0 - 25€" => 0, "26 - 50€" => 0, "51 - 100€" => 0, "101 - 250€" => 0, "251 - 500€" => 0, "501€ +" => 0}
        @sum_expenses = 0
        @low_sum_expenses = 0

        @subscriptions.each do |subscription|
            subscription_in_range = []
            subscription_decreasing_order = Subscription.order('price ASC').where(:software_plan_id => subscription.software_plan_id)
           range_user = (subscription.number_of_user - (1 + (subscription.number_of_user/2)**2))..(subscription.number_of_user + (1 + (subscription.number_of_user/2)**2))
           subscription_decreasing_order.each do |subscription|
               if range_user === subscription.number_of_user
                   subscription_in_range << subscription
               end
           end
           
           subscription.price == subscription_in_range[0].price ? @subscription_status["You already have the best plan"] += 1 : @subscription_status["Cheaper Plan Available"] += 1
           if (0..25) === subscription.price
            @subscription_range_price["0 - 25€"] += 1
           elsif (26..50) === subscription.price
            @subscription_range_price["26 - 50€"] += 1
           elsif (51..100) === subscription.price
            @subscription_range_price["51 - 100€"] += 1
           elsif (101..250) === subscription.price
            @subscription_range_price["101 - 250€"] += 1
           elsif (251..500) === subscription.price
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
        
        @expenses_per_month_2020 = @expenses_per_month.select{|key, value| key.include? "2020"}
        @low_expenses_per_month_2020 = @low_expenses_per_month.select{|key, value| key.include? "2020"}
        @sum_expenses_2020 = 0
        @expenses_per_month_2020.each { |key, value| @sum_expenses_2020 += value}
        @low_sum_expenses_2020 = 0
        @low_expenses_per_month_2020.each { |key, value| @low_sum_expenses_2020 += value }

    end

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

    private

    def params_company
        params.require(:company).permit(:name, :address, :country, :company_size, :turnover)
    end
end
