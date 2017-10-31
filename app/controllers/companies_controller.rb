class CompaniesController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show, :company_profile, :realestate ]
	before_action :verify, except: [:index, :company_profile, :show, :realestate]

	before_action :admin_check, only: [:new, :edit, :make_team, :make_profile, :edit_profile, :reject]
	before_action :set_company, only: [:show_unathorized, :company_profile, :reject, :edit_profile, :update, :make_profile, :remove_company, :show, :join_waitlist, :invest, :submit_payment, :reg_a_company, :waitlist, :join_waitlist_send_email_with_invest, :delete_document ]

	before_action :check_company_accreditation, only: [:show, :company_profile]

	def index
		@companies = Company.all_accredited
		@funded_companies = Company.all_funded
	end

	def realestate
		redirect_to 'https://realtyreturns.com/'
	end

	def company_profile
		@campaign = @company.campaign
		@financial_details = @company.financial_detail
		@comments = @company.comments
		@members = @company.founders.order(:position)
		@quote = @company.quotes.first
		@quote2 = @company.quotes.second
		@quote3 = @company.quotes.third
		@questions = @company.questions
		@timeline_items = @company.timeline_items.order(:position)
	end

	def show
		@financial_details = @company.financial_detail
		@comments = @company.comments
		@section = @company.sections.first
		@members = @company.founders.order(:position)
		@campaign = @company.campaign
		@quote = @company.quotes.first
		@quote2 = @company.quotes.second
		@quote3 = @company.quotes.third
		@formc = @company.general_info
		@questions = @company.questions
		@timeline_items = @company.timeline_items.order(:position)
	end

	def show_unathorized
		redirect_to company_path(@company)
	end

	def delete_document
		doc_name = params[:document] + "_file_name"
		@company.financial_detail.update(doc_name => nil)
		redirect_to @company
	end

	def remove_quote
		@quote =  CampaignQuote.find(params[:id])
		@company = @quote.company
		@quote.delete
		redirect_to @company
	end

	def edit_profile
	end

	def update
		@company.update(company_params)
		redirect_to company_path(@company)
	end

	def company_not_accretited
	end

	def join_waitlist_send_email_with_invest
		company_name = @company.name
		Guest.create(email: current_user.email, company: company_name, user_id: current_user.id)
		ContactMailer.join_waitlist_with_invest(@company, current_user, params[:invest_amount]).deliver
		redirect_to "/join_waitlist_thank_you"
	end

	def join_waitlist_thank_you
	end

	def explore
		@companies = Company.where(reg_a: true)
	end

	def reg_a_company
	end

	def reject
		ContactMailer.reject_company(@company).deliver
		redirect_to admin_companies_path, :alert => "Company was rejected. Email was sent."
	end

	def edit_campaign
		@campaign = Campaign.find(params[:id])
		@company = @campaign.company
		@campaign.testimonials.build
		@comments = @company.comments
		@members = @company.founders
		@formc = @company.general_info
		@questions = @company.questions
		@timeline_items = @company.timeline_items.order(:position)
		@quotes = @company.quotes
	end

	def update_campaign
	  @campaign = Campaign.find(params[:company][:campaign_attributes][:id])
	  @company = @campaign.company
	  @company.update(company_params)
	  redirect_to :controller => 'companies', :action => 'show', :id => @company.slug
	end

	def invest
		@company.delay(run_at: 1.day.from_now).invest_reminder(current_user)
		@company.delay(run_at: 3.days.from_now).invest_reminder(current_user)
		if current_user.entity_id
			begin
				@entity = FundAmerica::Entity.details( current_user.entity_id )
				@ach_authorization = FundAmerica::AchAuthorization.details( current_user.ach_id )
			rescue
				@entity, @ach_authorization = {}, {}
			end
		else
			@entity, @ach_authorization = {}, {}
		end
	end

	def submit_payment
		entity_array = FundAmericaPayment.new(params, current_user, request.remote_ip, @company).make_payment

		@investment, @error, @entity, @ach_authorization = entity_array[0], entity_array[1], entity_array[2], entity_array.last

		if @investment
			invstmnt = Investment.create(user_id: current_user.id, fund_america_id: @investment["id"], company_id: params[:id])
			redirect_to congratulation_path(invstmnt.id)
		else
			render :invest
		end
	end



private
	def set_company
	  @company = Company.friendly.find(params[:id])
	end

	def verify
	 	if current_user.confirmed == false
	 		redirect_to url_for(:controller => 'home', :action => 'unverified')
	 	end
	end

	def check_company_accreditation
		if @company.accredited
			return nil
		else
			if current_user
				check_company_ownership
			else
				redirect_to root_path
			end
		end
	end

	def check_company_ownership
		if @company == current_user.company || current_user.authority >= 3
			return
		else
			redirect_to company_not_accretited_path
		end
	end

	def admin_check
		if current_user.authority < User.Authority[:Editor]
			redirect_to url_for(:controller => 'home', :action => 'unauthorized')
		end
	end

	def section_params
		params.require(:section).permit(:id, :company_id, :overview, :target_market, :current_investor_details, :detailed_metrics, :customer_testimonials, :competitive_landscape, :planned_use_of_funds, :pitch_deck, :created_at, :updated_at)
	end

	def company_params
		params.require(:company).permit( Company::ACCESSIBLE_ATTRIBUTES,
		campaign_attributes: Campaign::ACCESSIBLE_ATTRIBUTES,
	  	testimonials_attributes: Testimonial::ACCESSIBLE_ATTRIBUTES,
      	quote_attributes: CampaignQuote::ACCESSIBLE_ATTRIBUTES,
    	quotes_attributes: CampaignQuote::ACCESSIBLE_ATTRIBUTES,
    	questions_attributes: [:id, :question, :answer, :_destroy],
    	general_info_attributes: [:id, investment_perks_attributes: InvestmentPerk::ACCESSIBLE_ATTRIBUTES],
		founders_attributes: [:id, :image, :name, :position, :title, :content, :company_id, :created_at, :updated_at, :_destroy],
	    documents_attributes: [:id, :file, :name, :company_id ],
	    timeline_items_attributes: [:id , :content, :created_date, :image, :position, :company_id, :_destroy ],
	    financial_detail_attributes: FinancialDetail::ACCESSIBLE_ATTRIBUTES  )
	end

	def founder_params
		params.require(:founder).permit(:image, :name, :position, :content, :company_id, :created_at, :updated_at)
	end
end
