class BidsController < ApplicationController

	#Default site that shows all startups
	def index
		@bids = Bid.where(user_id: user_session.id.to_s)
	end

  #improve associations later
  def sellers_bids
    @seller = user_session
    company_name = @seller.liquidate_shares.first.company
    @company = Company.find_by(name: company_name)
    @bids = Bid.where(company_id: @company.id)
  end

  def bid
    @company = Company.find(params[:id])
  end

  def new
    @bid = Bid.new
    if session[:current_user] == nil || session[:current_user].authority < User.Authority[:Founder]
      redirect_to url_for(:controller => 'home', :action => 'unauthorized')
    end
  end

  def create
    @bid = Bid.new(bid_params)
      if @bid.save
        redirect_to "/companies", notice: 'bid was successfully created.'
        #send email to all sellers
        #ContactMailer.bid_created().deliver
      else
        render :new
      end
  end

  def edit
  end

  def update
  end

  def show
    @company = Company.find(params[:id])
    @auctions = LiquidateShare.where(company: @company.name)
  end

  def accept
  end

  def decline
  end

  def counter_offer
  end

  private
  def bid_params
    params.require(:bid).permit(:auction_id, :user_id, :seller_id, :bid_amount, :counter_amount, :accepted, :company_id,:number_of_shares)
  end
end

