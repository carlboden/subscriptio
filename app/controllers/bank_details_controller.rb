class BankDetailsController < ApplicationController
    def new
        @bank_details = BankDetail.new
        @company = Company.find(current_user.company_id)
    end

    def create
        if valid_card?(params[:bank_detail][:card]) != true
            @bank_details = BankDetail.new
            @company = Company.find(current_user.company_id)
            @card_incorrect = "yes"
            render :new
            return 
        end
        @bank_details = BankDetail.new(bank_details_params)
        @date = params[:bank_detail][:expiration_date]
        @date = @date.split(".")
        @expiration_date = Date.new("20#{@date[1]}".to_i, @date[0].to_i, 1)
        if Date.today > @expiration_date
            @bank_details = BankDetail.new
            @company = Company.find(current_user.company_id)
            @card_not_valid = "yes"
            render :new
            return 
        end
        @bank_details.expiration_date = @expiration_date    
        @company = Company.find(current_user.company_id)
        @company.subscriptio_plan_id = 2
        @bank_details.user = current_user
        @bank_details.company = @company
        if @bank_details.save
            @company.save
            redirect_to company_path(@company)
        else
            if params[:bank_detail][:cvv].length != 3 
                @cvv_incorrect = "cvv incorrect"
            end
            render :new
        end
    end

    def valid_card?(card)
        digits = card.delete(" ").split("").map { |digit| digit.to_i }
        return false if digits.empty?
      
        sum = luhn_sum(digits)
        (sum % 10).zero?
    end
      
    def luhn_sum(digits)
        sum = 0
        digits.each_with_index do |digit, index|
            if index.even?
            sum += digit * 2 >= 10 ? (digit * 2) - 9 : digit * 2
            else
            sum += digit
            end
        end
        sum
    end      

    def destroy
        @bank_details = BankDetail.find(params[:id])
        @company = Company.find(current_user.company_id)
        @company.subscriptio_plan_id = 1
        @company.save
        @bank_details.destroy
        redirect_to company_path(current_user.company_id)
    end

    private

    def bank_details_params
        params.require(:bank_detail).permit(:card, :cvv)
    end
end
