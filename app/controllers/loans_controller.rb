class LoansController < ApplicationController
  def index
  	@loans = Loan.all
  end
  def new
  	@loan = Loan.new
  end
  def show
  	@loan = Loan.find(params[:id])
  	loan_action
  end
  def create
  	@loan = Loan.new(loan_params)
		if @loan.save
			redirect_to @loan
		else
			render 'new'
		end
  end
  def edit
	@loan = Loan.find(params[:id])
  end
  def update
	@loan = Loan.find(params[:id])
	 
	if @loan.update(loan_params)
		redirect_to @loan
	else
		render 'edit'
  	end
  end
  def destroy
		@loan = Loan.find(params[:id])
		@loan.destroy

		redirect_to loans_path
	end
  def loan_action
  	@amount = Integer(@loan.amount)
  	@year = Integer(@loan.year)
  	@interest = Float(@loan.interest)
	monthly_interest = @interest / (12 * 100)
	
	@total_month = @year * 12
	math_pow_value = 1 - (1 + monthly_interest) ** ((-1) * @total_month)
	@monthly_payment = @amount * (monthly_interest / math_pow_value)
	@interest_set = Array.new
	@principle_set = Array.new
	@balance_set = Array.new
	@interest_total_set = Array.new

	amount_balance = @amount
	for i in 0..(@total_month - 1)
		interest_value = amount_balance * monthly_interest
		principle_value = @monthly_payment - interest_value
		amount_balance = amount_balance - principle_value
		@interest_set.push(interest_value)
		@principle_set.push(principle_value.round(2))
		@balance_set.push(amount_balance.round(2))
		@interest_total_set.push(@interest_set.inject(:+).round(2))
	end
	 respond_to do |format|
	     format.html { render "report" }
	 end
  end
  def self.currency_format(number_input)
  	ActionController::Base.helpers.number_to_currency(number_input ,precision: 2,unit: '')
  end
  private
		def loan_params
			params.require(:loan).permit(:amount, :year, :interest)
		end
end
