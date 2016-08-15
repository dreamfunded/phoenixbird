class FormcController < ApplicationController
  before_action :authenticate_user!

  def general
    @general_info = GeneralInfo.new
  end

  def general_save
    info = GeneralInfo.create(general_info_params)
    current_user.companies.last.general_info << info
    redirect_to action: :business, id: info.id
  end

  def business
    @general_info = GeneralInfo.find(params[:id])
  end

  def business_save
    @general_info = GeneralInfo.find(params[:id])
    @general_info.update(general_info_params)
    redirect_to action: :people, id: @general_info.id
  end

  def people
    @general_info = GeneralInfo.find(params[:id])
    if @general_info.officers.count > 0
      @officers = @general_info.officers
    else
      @officer = Officer.new(position: 'CEO')
    end
    @securities = [Security.new(security_class: 'Common Stock'), Security.new(security_class: 'Debt Securities')]
    @securities_reserver = [Security.new(security_class: 'Warrants'), Security.new(security_class: 'Options')]
  end

  def people_save
    @general_info = GeneralInfo.find(params[:id])
    @general_info.update(general_info_params)
    redirect_to action: :disclosures, id: @general_info.id
  end

  def terms
    @general_info = GeneralInfo.find(params[:id])
    @perks = [InvestmentPerk.new(amount: 250), InvestmentPerk.new(amount: 500),InvestmentPerk.new(amount: 1000), InvestmentPerk.new(amount: 5000)]
    @term = Term.new
  end

  def terms_save
    @general_info = GeneralInfo.find(params[:id])
    @general_info.update(general_info_params)
    redirect_to action: :disclosures, id: @general_info.id
  end

  def disclosures
    @general_info = GeneralInfo.find(params[:id])
    @risk = Risk.new
    @tier = FundraiseTier.new(amount: 20000)
  end

  def disclosure_save
    @general_info = GeneralInfo.find(params[:id])
    @general_info.update(general_info_params)
    redirect_to action: :financials, id: @general_info.id
  end

  def financials
    @general_info = GeneralInfo.find(params[:id])

    if @general_info.financial_detail.nil?
      @general_info.financial_detail = FinancialDetail.new
    end
    @financial_detail = @general_info.financial_detail
  end

  def financials_save
     @general_info = GeneralInfo.find(params[:id])
     @general_info.update(general_info_params)
     redirect_to action: :print, id: @general_info.id

  end

  def print
    @general_info = GeneralInfo.find(params[:id])
    @company = @general_info.company
    render :layout => false
  end

private
  def general_info_params
    params.require(:general_info).permit("name", "days", "cap_table", "kind", "state", "date_formed", "employees_numer", "company_location_address", "company_location_city", "company_location_state", "company_location_zipcode",
                                         "website", "employer_id_number", "financial_condition", "outstanding_loan","business_model", "business_plan",
                                         :business_history, :product_description, :competition, :customer_base, :intellectual_property,
                                         :governmental_regulatory, :litigation, :phone,
        securities_attributes: [:security_class,  :_destroy, :amount, :outstanding, :voting_rights, :other_rights, :general_info_id, :securities_reserved, :created_at, :updated_at],
        principal_holders_attributes: [:name, :securities_held, :_destroy, :voting_power, :general_info_id, :created_at, :updated_at],
        officers_attributes: [ "name", "email", "year_joined", "_destroy", "officers", "director", "position", "education", "occupation", "main_employer", "general_info_id", "created_at", "updated_at"],
        investment_perks_attributes: [:content, :amount,:_destroy],
        terms_attributes: [
          "safe_cap", "valuation_cap", "_destroy", "investor_threshold", "pro_rata?", "governing_law_state", "days", "raised_this_round", "discount", "store_credit", "store_discount", "general_info_id"
        ],
        fundraise_tiers_attributes: [:id, :content, :amount, :_destroy],
        risks_attributes: [:id, :content, :_destroy],
        financial_detail_attributes: ["id", "general_info_id", "sustain_amount", "total_taxable_income", "total_assets_this_year", "total_assets_last_year", "cash_this_year", "cash_last_year", "acount_receivable_this_year", "acount_receivable_last_year", "short_term_debt_this_year", "short_term_debt_last_year", "long_term_debt_this_year", "long_term_debt_last_year", "sales_this_year", "sales_last_year", "costs_of_goods_this_year", "costs_of_goods_last_year", "taxes_paid_this_year", "taxes_paid_last_year", "net_income_this_year", "net_income_last_year", ]

      )
  end

end