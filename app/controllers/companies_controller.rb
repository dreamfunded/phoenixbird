class CompaniesController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show, :company_profile ]
	before_action :verify, except: [:index, :company_profile, :show]
	before_action :admin_check, only: [:new, :edit, :make_team, :make_profile]
	before_action :set_company, only: [:company_profile, :edit_profile, :update, :make_profile, :remove_company, :show, :join_waitlist, :invest, :submit_payment ]
	before_action :check_company_accreditation, only: [:show, :company_profile]

	def index
		@companies = Company.all_accredited
	end

	def company_profile
		if params[:id] != nil
			@id = params[:id]
			@financial_details = @company.financial_detail
			@progress = @company.invested_amount / @company.goal_amount rescue 0
			@comments = @company.comments
			@members = @company.founders.order(:position)
			@section = @company.sections.first
		else
			redirect_to "/companies"
		end
	end

	def show
		if params[:id] != nil
			@id = params[:id]
			@financial_details = @company.financial_detail
			@progress = @company.invested_amount / @company.goal_amount rescue 0
			@comments = @company.comments
			@members = @company.founders.order(:position)
			@section = @company.sections.first
		else
			redirect_to "/companies"
		end
	end

	def edit_profile
		if current_user == nil || current_user.authority < User.Authority[:Admin]
			redirect_to url_for(:controller => 'home', :action => 'unauthorized')
		end
	end

	def update
		if @company.update(company_params)
			redirect_to company_path(@company)
		else
			@error_update = ""
			@company.errors.full_messages.each do |error|
				@error_update = @error_update + error + ". "
			end
			flash[:problem_update] = @error_update
			redirect_to :controller => 'companies', :action => 'edit_profile', :id => params[:id]
		end
	end

	def new
		redirect_to funding_goal_path
		@company = Company.new
	end

	def create
		@company = Company.new(company_params)
		if @company.save
			@company.campaign = Campaign.create
			@company.sections << Section.new
			redirect_to "/companies"
		else
			@error_message = ""
			@company.errors.full_messages.each do |error|
				@error_message = @error_message + error + ". "
			end
			flash[:message] = @error_message
			redirect_to "/companies/new"
		end
	end

	def edit
		@companies = Company.all
	end

# can be refactored
	def action
		@my_company = Company.find_by(id: params[:id])
		if @my_company == nil
			@message = ""
			@message = "No company with that ID exists. Please create the company first."
			flash[:fail] = @message
			redirect_to url_for(:controller => 'companies', :action => 'edit')
		elsif params[:id] != nil && params[:desired_action] == "1"
			redirect_to url_for(:controller => 'companies', :action => 'make_team', :id => params[:id])
		elsif params[:id] != nil && params[:desired_action] == "2"
			redirect_to url_for(:controller => 'companies', :action => 'make_profile', :id => params[:id])
		end
	end

	def make_team
		@founder = Founder.new
		@companies = Company.all
	end

	def add_team_member
		@founder = Founder.new(founder_params)
		if @founder.save
			redirect_to "/companies"
		else
			redirect_to "/companies/make_team"
		end
	end

	def make_profile
		@section = @company.sections.first
	end

	def submit_profile
		@company = Company.find(params[:section][:id])
		@section = @company.sections.first

		if @section.update(section_params)
			redirect_to "/companies"
		else
			@error_message3 = ""
			section.errors.full_messages.each do |error|
				@error_message3 = @error_message3 + error + ". "
			end
			flash[:problem] = @error_message3
			redirect_to "/companies/make_profile/#{@company.id}"
		end
	end

	def remove_company
    	@company.destroy
   		redirect_to "/companies"
	end

	def remove_founder
    	@founder = Founder.find(params[:id])
    	@company = @founder.company
    	@founder.destroy
    	redirect_to company_path(@company)
 	end

	def join_waitlist
	end

	def join_waitlist_send_email
		company_name = params[:company_name]
		@name = params[:name]
		@email = params[:email]
		@phone = params[:phone]
		@message = params[:message]
		Guest.create(email: params[:email], company: company_name, user_id: current_user.id)
		ContactMailer.contact_us_email(@name, @email, @phone, @message).deliver
		flash[:thank_you_notice] = 'Thank you'
		redirect_to "/join_waitlist_thank_you"
	end

	def join_waitlist_thank_you
	end

	def company_not_accretited
	end

	def invest
		@entity, @ach_authorization = {}, {}
		@entity = FundAmerica::Entity.details( current_user.entity_id ) if current_user.entity_id
		@ach_authorization = FundAmerica::AchAuthorization.details( current_user.ach_id ) if current_user.ach_id
	end



	def submit_payment
		options = entity_options(params)

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
			    Investment.create(user_id: current_user.id, fund_america_id: @investment["id"], company_id: params[:id])
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
			redirect_to portfolio_path
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
		  :state => 'California',
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
	  params.require(:company).permit(:image, :min_investment, :cover, :id, :end_date, :document, :hidden, :position, :docusign_url, :name,
	  	:description, :image, :invested_amount, :website_link, :video_link, :goal_amount, :status, :CEO, :CEO_number,
	   :display, :days_left, :created_at, :updated_at, :suggested_target_price, :fund_america_code,
	  financial_detail_attributes: ["offering_terms", "fin_risks", "income", "totat_income", "total_taxable_income",
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
