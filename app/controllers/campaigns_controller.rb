class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify

  def funding_goal
    @company = Company.new
  end

  def funding_goal_submit
    funding_goal = params[:campaign][:funding_goal].delete('$').delete(',').to_i
    @company = Company.new(goal_amount: funding_goal, status: 1)
    @company.users << current_user
    current_user.make_founder
    if @company.save
      @company.sections << Section.new
      @campaign = Campaign.create(funding_goal: funding_goal, company_id: @company.id)
    @campaign.basics
      FinancialDetail.create(company_id: @company.id)
      redirect_to campaign_basics_path(@campaign.id)
    else
      render :funding_goal
    end
  end

  def funding_goal_exist
    @campaign = Campaign.find(params[:id])
  end

  def funding_goal_update
    funding_goal = params[:campaign][:funding_goal].delete('$').delete(',').to_i
    @campaign = Campaign.find(params[:campaign_id])
    @campaign.update(funding_goal: funding_goal)
    redirect_to campaign_basics_path(@campaign.id)
  end

  def basics
    #@campaign_id = params[:id]
    #@campaign = Campaign.find(params[:id])
    @company = Company.new
    @founders = @company.founders
  end

  def basics_submit
    @company = Company.new(company_params)
    if @company.save
      @company.users << current_user
      current_user.make_founder
      current_user.update(phone: params[:phone])
      @campaign = Campaign.create(funding_goal: 1000000, company_id: @company.id)
      @campaign.basics
      @campaign.description
      FinancialDetail.create(company_id: @company.id)
      @campaign.update( tagline: params[:tagline], category: params[:category])
      @company.delay(run_at: 1.day.from_now).submit_application(current_user)
      @company.delay(run_at: 3.days.from_now).submit_application(current_user)
      redirect_to description_path(@campaign.id)
    else
      p @company.errors
      render :basics
    end
  end

  def basics_exist
    @campaign = Campaign.find(params[:id])
    @campaign = Campaign.find(params[:id])
    @company = @campaign.company
  end

  def basics_exist_submit
    @company = Company.find(params[:company_id])
    @campaign = @company.campaign
    @company.update(company_params)
    redirect_to description_path(@campaign.id)
  end



  def description
    @campaign_id = params[:id]
    @campaign = Campaign.find(@campaign_id)
    @company = @campaign.company
  end

  def company_description_submit
    @company = Company.find(params[:company_id])
    youtube_url = youtube_url(params[:video_link])
    @company.update(video_link: youtube_url)
    @campaign = Campaign.find(params[:campaign_id])
    @campaign.update(campaign_params)
    @campaign.legal
    redirect_to legal_info_path(@campaign.id)
  end

  def legal_info
    @campaign = Campaign.find(params[:id])
    @company = @campaign.company
  end

  def legal_info_submit
    @campaign = Campaign.find(params[:campaign_id])
    @campaign.update(campaign_params)
    @campaign.financial
    @campaign.complete
    ContactMailer.campaign_submitted(current_user).deliver
    ContactMailer.check_campaign(@campaign).deliver
    redirect_to invite_contacts_path(@campaign.id)
  end

  def invite_contacts
    @campaign = Campaign.find(params[:id])
    session[:campaign_id] = params[:id]
    @company = @campaign.company
    @hash = {}
    #redirect_to company_path(@campaign.company)
  end

  def linked_invites
    @campaign = Campaign.find(params[:id])
    @company = @campaign.company
  end

  def upload_csv
    @company = Company.find(params[:company_id])
    begin
        @csv_file = CsvFile.new(csv_file_params)
        if @csv_file.save
          ContactMailer.delay.file_uploaded(current_user)
          redirect_to  company_path(@company)
        else
          flash[:upload_error] = "Invalid CSV file format."
          render :linked_invites
        end
     rescue
        redirect_to  company_path(@company)
    end
  end

  def financial_info
    @campaign = Campaign.find(params[:id])
    @financial_details = @campaign.company.financial_detail
  end

  def financial_info_submit
    @campaign = Campaign.find(params[:campaign_id])
    @financial_details = FinancialDetail.find(params[:financial_details])
    @financial_details.update(financial_details_params)
    @campaign.complete
    ContactMailer.campaign_submitted(current_user).deliver
    ContactMailer.check_campaign(@campaign).deliver
    redirect_to company_path(@campaign.company)
  end

  def edit_campaign
    @testimonials_limit = Campaign::TESTIMONIALS_LIMIT
    @campaign = Campaign.find(params[:id])
    @company = @campaign.company

    unless @campaign.testimonials.size >= @testimonials_limit
      @campaign.testimonials.build
    end
    # if current_user.company != @company
    #   redirect_to company_path(@company)
    # end
    @formc = @company.general_info
    @members = @company.founders
    @comments = @company.comments
    @campaign_quote = @campaign.quote || @campaign.build_quote
  end

  def update_campaign
    @campaign = Campaign.find(params[:company][:campaign_attributes][:id])
    @company = @campaign.company
    @company.update(company_params)
    redirect_to :controller => 'companies', :action => 'show', :id => @company.slug
  end


  def team
    @company = current_user.company
    @campaign = @company.campaign
    @team = @company.users.order(:created_at)
  end


  private
  def verify
    if current_user.confirmed == false
      redirect_to url_for(:controller => 'home', :action => 'unverified')
    end
  end

  def company_params
     params.require(:company).permit(:image, :id, :cover, :name, :description, :video_link, :user_id, :goal_amount, :website_link, :category,
                     campaign_attributes: [:tagline, :elevator_pitch, :about_campaign, :id, :category, :employees_numer, :company_location_city, :company_location_state, :business_plan,
                      testimonials_attributes: [:id, :name, :position, :photo, :message],
                      quote_attributes: [:id, :main, :description, :said_by, :position, :photo]],
                     founders_attributes: [:id, :image, :name, :position, :title, :content, :company_id, :created_at, :updated_at, :_destroy],
                     documents_attributes: [:id, :file, :name, :company_id ],
                     financial_detail_attributes: ["id", "offering_terms", "fin_risks", "income", "totat_income", "total_taxable_income",
                       "total_taxes_paid", "total_assets_this_year", "total_assets_last_year", "cash_this_year", "cash_last_year",
                       "acount_receivable_this_year", "acount_receivable_last_year", "short_term_debt_this_year", "short_term_debt_last_year",
                       "long_term_debt_this_year", "long_term_debt_last_year", "sales_this_year", "sales_last_year", "costs_of_goods_this_year",
                       "costs_of_goods_last_year", "taxes_paid_this_year", "taxes_paid_last_year", "net_income_this_year", "net_income_last_year",
                       "company_id","balance_sheet", "income_statements", "statement_of_cash_flow", "statement_changes_of_equity",
                       "business_plan", "party_transaction", "intended_use_of_proceeds", "capital_structure", "material_terms",
                        "financial_conditions", "directors_background", "accountant_review"]
                     )
  end

  def campaign_params
    params.require(:campaign).permit( "funding_goal", "tagline", "category", "elevator_pitch", "tags", "about_campaign", "employees_numer", "legal_company_name", "employer_id_number", "state_where_incorporated", "office_location", "date_formed", "company_location_address", "company_location_city", "company_location_state", "company_location_zipcode", "company_contact_info_name", "company_contact_info_email", "company_contact_info_phone", "legal_contact_info_name", "legal_contact_info_email", "legal_contact_info_phone", "legal_contact_info_firm", "legal_contact_info_website", "accounting_info_name", "accounting_info_email", "accounting_info_phone", "accounting_info_firm", "accounting_info_website", "state_filing_number","offering_terms",
    "financial_risks", "totat_income", "total_taxable_income", "total_taxes_paid",   )
  end

  def founder_params
    params.require(:founder).permit(:image, :name, :position, :content, :company_id, :created_at, :updated_at)
  end

  def csv_file_params
    params.require(:csv_file).permit(:user_id, :file)
  end

  def financial_details_params
    params.require(:financial_detail).permit(
      "offering_terms", "fin_risks", "income", "totat_income", "total_taxable_income", "total_taxes_paid", "total_assets_this_year", "total_assets_last_year", "cash_this_year", "cash_last_year", "acount_receivable_this_year", "acount_receivable_last_year", "short_term_debt_this_year", "short_term_debt_last_year", "long_term_debt_this_year", "long_term_debt_last_year", "sales_this_year", "sales_last_year", "costs_of_goods_this_year", "costs_of_goods_last_year", "taxes_paid_this_year", "taxes_paid_last_year", "net_income_this_year", "net_income_last_year", "company_id",
      "balance_sheet", "income_statements", "statement_of_cash_flow", "statement_changes_of_equity", "business_plan", "party_transaction", "intended_use_of_proceeds", "capital_structure", "material_terms", "financial_conditions", "directors_background", "accountant_review"    )
  end

  def youtube_url(url)
    if url.include? "youtube"
      code = url.split("/watch?v=").last
      youtube_url = "https://www.youtube.com/embed/" + code
    else
      ""
    end
  end

end
