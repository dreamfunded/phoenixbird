class PaymentsController < ApplicationController
  before_action :authorize

  def index
	end

  def payment
    tran=UmTransaction.new

    # Merchants Source key must be generated within the console
    tran.key="azIZnB64RLfnc7yFhWbidTGTgkdq5p36"

    # Send request to sandbox server not production.  Make sure to comment or remove this line before
    #  putting your code into production
    tran.usesandbox=false

    # tran.card="4111111111111111"
    # tran.exp="0919"
    tran.command="check:sale"
    tran.amount= params[:amount]
    tran.invoice="1234"
    #tran.cardholder="Test T Jones"
    #tran.street="1234 Main Street"
    #tran.zip="90036"
    tran.description="Online Order"
    #tran.cvv2="435"
    # tran.custom3="testest"
    #tran.pin="1234"
    tran.ip = request.remote_ip
    tran.dlnum = 'F2127533'
    tran.dlstate = 'CA'
    tran.cardholder = params[:name]
    tran.routing = params[:routing]
    tran.account = params[:account]


    $stdout.flush

    tran.process
    flash[:message] = tran.error
    if tran.resultcode.to_s=="A"
    then
      flash[:message] = tran.result
      p "Full result #{tran.result}"
      p "Authcode:  #{tran.authcode} "
      p "AVS Result: #{tran.avs_result} "
      p "Cvv2 Result: #{tran.cvv2_result} "
    else

      p "Card Declined #{tran.result} "
      p "Reason: #{tran.error}"
    end
    redirect_to payment_path
  end

  private

  def authorize
    if session[:current_user] == nil || session[:current_user].authority < User.Authority[:Admin]
      redirect_to url_for(:controller => 'home', :action => 'unauthorized')
    end
  end

end
