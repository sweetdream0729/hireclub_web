class BankAccountsController < ApplicationController
  def new
  	@bank_account = BankAccount.new
  	
  	if current_user.is_provider?
  		@provider = current_user.provider
  	else
  		redirect_to new_provider_path
  	end

  end

  def create
  	create_bank_account = BankAccount::CreateBankAccount.new(params[:stripeToken], current_user.provider )
  	@bank_account = create_bank_account.call
  	if !@bank_account.id.nil?
  		redirect_to current_user.provider, notice: "Bank account added successfully"
  	else
  		render :new
    end
  end
end
