class CompaniesController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show, :company_profile ]
	before_action :verify, except: [:index, :company_profile, :show]
	before_action :admin_check, only: [:new, :edit, :make_team, :make_profile, :edit_profile]
	before_action :set_company, only: [:company_profile, :edit_profile, :update, :show, :join_waitlist, :reg_a_company, :waitlist]
	before_action :check_company_accreditation, only: [:show, :company_profile]

	def index
		@companies =
			Company.select('companies.*, (followers.id IS NOT NULL) as followed_by_current_user').
				joins("LEFT JOIN followers ON companies.id = followers.company_id").all_accredited
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
	end

	def edit_profile
	end

	def update
		@company.update(company_params)
		redirect_to company_path(@company)
	end

	def company_not_accretited
	end

	def explore
		@companies = Company.where(reg_a: true)
	end

	def reg_a_company
	end

	def edit_campaign
	  @campaign = Campaign.find(params[:id])
	  @company = @campaign.company
	  @formc = @company.general_infos.last
	  @members = @company.founders
	  @comments = @company.comments
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
	  params.require(:company).permit(:image, :min_investment, :cover, :id, :end_date, :document, :hidden, :position, :docusign_url,
	   :name, :description, :image, :invested_amount, :website_link, :video_link, :goal_amount, :status, :CEO, :CEO_number,
	   :display, :days_left, :created_at, :updated_at, :suggested_target_price, :fund_america_code, :reg_a,
	   campaign_attributes: [:tagline, :elevator_pitch, :about_campaign, :id, :category, :employees_numer, :company_location_city, :company_location_state],
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
