class CompaniesController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show, :company_profile ]
	before_action :verify, except: [:index, :company_profile, :show]

	before_action :admin_check, only: [:new, :edit, :make_team, :make_profile, :edit_profile]
	before_action :set_company, only: [:show_unathorized, :company_profile, :edit_profile, :update, :make_profile, :remove_company, :show, :join_waitlist, :invest, :submit_payment, :reg_a_company, :waitlist, :join_waitlist_send_email_with_invest, :delete_document ]

	before_action :check_company_accreditation, only: [:show, :company_profile]

	def index
		@companies = Company.all_accredited
		@funded_companies = Company.all_funded
	end

	def company_profile
		@financial_details = @company.financial_detail
		@comments = @company.comments
		@members = @company.founders.order(:position)
	end

	def show
		@financial_details = @company.financial_detail
		@comments = @company.comments
		@section = @company.sections.first
		@members = @company.founders.order(:position)
		@campaign = @company.campaign
		@quote = @company.quote
		@formc = @company.general_info
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

	def edit_campaign
		@campaign = Campaign.find(params[:id])
		@company = @campaign.company
		@campaign.testimonials.build
		@comments = @company.comments
		@members = @company.founders
		@formc = @company.general_info
		if @company.quote == nil
			@quote = CampaignQuote.new
		else
			@quote = @company.quote
		end
	end

	def update_campaign
	  @campaign = Campaign.find(params[:company][:campaign_attributes][:id])
	  @company = @campaign.company
	  @financial_detail = @company.financial_detail

	  @company.update(company_params)
	  @campaign.update(tagline: params[:company][:campaign_attributes][:tagline],
	  				  elevator_pitch: params[:company][:campaign_attributes][:elevator_pitch],
	  				  about_campaign: params[:company][:campaign_attributes][:about_campaign],
	  				  category: params[:company][:campaign_attributes][:category],
	  				  employees_numer: params[:company][:campaign_attributes][:employees_numer],
	  				  company_location_city: params[:company][:campaign_attributes][:company_location_city],
	  				  company_location_state: params[:company][:campaign_attributes][:company_location_state])
	  @financial_detail.update(offering_terms:  params[:company][:financial_detail_attributes][:offering_terms],
	  						  fin_risks:  params[:company][:financial_detail_attributes][:fin_risks])
	  redirect_to :controller => 'companies', :action => 'show', :id => @company.slug
	end

	def invest
		@company.delay(run_at: 1.day.from_now).invest_reminder(current_user)
		@company.delay(run_at: 1.days.from_now).invest_reminder(current_user)
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
		options = entity_options(params)
		@error = {}
		@entity, @ach_authorization = {}, {}
		if current_user.entity_id
			begin
				@entity = FundAmerica::Entity.update(current_user.entity_id, options)
			rescue FundAmerica::Error => e
			    p 'ERROR'
			    @entity, @ach_authorization = {}, {}
			    puts e.parsed_response
			    @error = e.parsed_response
			end
		else
			begin
				@entity = FundAmerica::Entity.create(options)
			rescue FundAmerica::Error => e
			    p 'ERROR'
			    puts e.parsed_response
			    @error = e.parsed_response
			end
		end

		p @entity

		if @entity
			current_user.update(entity_id: @entity["id"])
			if params[:ach] == 'exist'
				@ach_authorization = FundAmerica::AchAuthorization.details( current_user.ach_id )
			else
				ach_auth_options = get_ach_options(params, @entity)
				begin
				    @ach_authorization = FundAmerica::AchAuthorization.create(ach_auth_options)
					p "ACH"
					p @ach_authorization
				rescue FundAmerica::Error => e
				    p 'ERROR'
				    puts e.parsed_response
				    @error = @error.merge(e.parsed_response)
				end
			end
		end

		if @entity && @ach_authorization
			current_user.update(ach_id: @ach_authorization["id"] )
			investment_options = get_investment_options(params, @company, @entity, @ach_authorization)
			begin
			    @investment = FundAmerica::Investment.create(investment_options)

			    invstmnt = Investment.create(user_id: current_user.id, fund_america_id: @investment["id"], company_id: params[:id])
			    ContactMailer.investment_made( current_user).deliver
			    ContactMailer.new_investment_made(current_user, params[:id]).deliver
			rescue FundAmerica::Error => e
			    p 'ERROR'
			    puts e.parsed_response
			    @error = @error.merge(e.parsed_response)
			end
			p "INVESTMENT"
			p @investment
		end

		if @investment
			#redirect_to portfolio_path
			redirect_to congratulation_path(invstmnt.id)
		else
			render :invest
		end
	end



private
	def entity_options(params)
		date_of_birth = params[:birth_date] + '/' + params[:birth_month] + '/' + params[:birth_year]
		options = {
		   :city => params[:city],
		   :country => 'US',
		   :email => current_user.email,
		   :name => params[:name],
		   :phone => params[:phone],
		   :postal_code => params[:zipcode],
		   :region => params[:state],
		   :street_address_1 => params[:address],
		   :tax_id_number => params[:ssn],
		   :type => "person",
		   :date_of_birth => date_of_birth
		}
	end

	def get_ach_options(params, entity)
		get_ach_options = {
		  :name_on_account => params[:name],
		  :account_number => params[:account_number],
		  :routing_number => params[:routing_number],
		  :account_type => params[:account_type],
		  :check_type => params[:check_type],
		  :email => params[:email],
		  :entity_id => entity['id'],
		  :ip_address => request.remote_ip,
		  :literal => "Test User",
		  :phone => params[:phone],
		  :address => params[:address],
		  :city => params[:city],
		  :state => params[:state],
		  :zip_code => params[:zipcode]
		}
	end

	def get_investment_options(params, company, entity, ach)
		investment_options = {
		    amount: params[:amount],
		    equity_share_count: params[:amount],
		    offering_id: company.offering_code,
		    payment_method: "ach",
		    entity_id: entity["id"],
		    ach_authorization_id: ach["id"]
		}
	end


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
	  params.require(:company).permit(:image, :min_investment, :cover, :id, :end_date, :document, :hidden, :position, :docusign_url,
	   :name, :description, :image, :invested_amount, :website_link, :video_link, :goal_amount, :status, :CEO, :CEO_number,
	 :display, :days_left, :created_at, :updated_at, :suggested_target_price, :fund_america_code, :reg_a, :category,
	  campaign_attributes: [*Campaign::ACCESSIBLE_ATTRIBUTES,
	  						testimonials_attributes: Testimonial::ACCESSIBLE_ATTRIBUTES,
      						quote_attributes: CampaignQuote::ACCESSIBLE_ATTRIBUTES
      						],
      quote_attributes: CampaignQuote::ACCESSIBLE_ATTRIBUTES,
     general_info_attributes: [:id, investment_perks_attributes: InvestmentPerk::ACCESSIBLE_ATTRIBUTES],

	   founders_attributes: [:id, :image, :name, :position, :title, :content, :company_id, :created_at, :updated_at, :_destroy],
	   documents_attributes: [:id, :file, :name, :company_id ],
	  financial_detail_attributes: ["id", "offering_terms", "fin_risks", "income", "totat_income", "total_taxable_income",
				       "total_taxes_paid", "total_assets_this_year", "total_assets_last_year", "cash_this_year", "cash_last_year",
				       "acount_receivable_this_year", "acount_receivable_last_year", "short_term_debt_this_year", "short_term_debt_last_year",
				       "long_term_debt_this_year", "long_term_debt_last_year", "sales_this_year", "sales_last_year", "costs_of_goods_this_year",
				       "costs_of_goods_last_year", "taxes_paid_this_year", "taxes_paid_last_year", "net_income_this_year", "net_income_last_year",
				       "company_id","balance_sheet", "income_statements", "statement_of_cash_flow", "statement_changes_of_equity",
				       "business_plan", "party_transaction", "intended_use_of_proceeds", "capital_structure", "material_terms",
				        "financial_conditions", "directors_background", "accountant_review"]  )
	end

	def founder_params
		params.require(:founder).permit(:image, :name, :position, :content, :company_id, :created_at, :updated_at)
	end
end
