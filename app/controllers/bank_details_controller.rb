class BankDetailsController < ApplicationController
    def new
        @bank_details = BankDetail.new
        @company = Company.find(current_user.company_id)
    end

    def create
        @bank_details = BankDetail.new(bank_details_params)
        @company = Company.find(current_user.company_id)
        @company.subscriptio_plan_id = 2
        @bank_details.user = current_user
        @bank_details.company = @company
        if @bank_details.save
            @company.save
            redirect_to company_path(@company)
        else
            render :new
        end
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
        params.require(:bank_detail).permit(:iban, :cvv, :expiration_date)
    end
end
