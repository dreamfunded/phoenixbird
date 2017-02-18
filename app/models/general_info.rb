class GeneralInfo < ActiveRecord::Base
  belongs_to :company, inverse_of: :general_info

  has_one :financial_detail
  accepts_nested_attributes_for :financial_detail, reject_if: :all_blank, allow_destroy: true

  has_many :officers
  accepts_nested_attributes_for :officers, reject_if: :all_blank, allow_destroy: true

  has_many :principal_holders
  accepts_nested_attributes_for :principal_holders, reject_if: :all_blank, allow_destroy: true

  has_many :securities
  accepts_nested_attributes_for :securities, reject_if: :all_blank, allow_destroy: true

  has_many :terms
  accepts_nested_attributes_for :terms, reject_if: :all_blank, allow_destroy: true

  has_many :investment_perks, inverse_of: :general_info
  accepts_nested_attributes_for :investment_perks, reject_if: -> (attributes) {attributes['content'].blank? }, allow_destroy: true

  has_many :risks
  accepts_nested_attributes_for :risks, reject_if: :all_blank, allow_destroy: true

  has_many :fundraise_tiers
  accepts_nested_attributes_for :fundraise_tiers, reject_if: :all_blank, allow_destroy: true

  def address
    self.company_location_address + ", "+ self.company_location_city + ", " + self.company_location_state + ", " +  self.company_location_zipcode
  end

  def dead_line
    Date.today + self.days
  end

  def team_names
    self.principal_holders.map(&:name).join(", ")
  end

  def team_titles
    self.principal_holders.map(&:title).join(", ")
  end


  def addit_financing
    self.additional_financing ? 'Will' : 'Will not'
  end

  def add_sources_capital
    self.additional_sources_capital ? 'Does' : 'Does not'
  end

  def add_sources_necessary
    self.additional_sources_necessary ? 'Are' : 'Are not'
  end

  def has_material_captl
    self.has_material_capital ? 'Have' : 'Have not'
  end

  def type_of_security
    type_of_securtity
  end

  def build_or_get_investment_perks
    return investment_perks if investment_perks.present?
    5.times do |n|
      amount = 250 * (n + 1)
      investment_perks.build(amount: amount)
    end
  end

end
