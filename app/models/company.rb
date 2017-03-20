class Company < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :all_accredited, -> {
    order(:position).where(hidden: false, accredited: true).where.not(status: 3)
  }

	has_many :users
  has_many :followers, inverse_of: :company
  has_many :user_followers, through: :followers, source: :user, inverse_of: :company

  def self.all_funded
    all.order(:position).where(hidden: false, accredited: true, status: 3)
  end



  has_many :investments
  has_many :sections
  has_many :comments
  has_many :bids
  has_many :founders
  accepts_nested_attributes_for :founders, reject_if: :all_blank, allow_destroy: true
  has_many :documents
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true
  has_many :liquidate_shares

  has_many :docusigns
  has_one :campaign
  has_many :general_infos
  has_one :general_info, -> { order('id DESC') }, inverse_of: :company
  has_one :financial_detail
  accepts_nested_attributes_for :financial_detail
  accepts_nested_attributes_for :campaign
  accepts_nested_attributes_for :general_info, reject_if: :all_blank, allow_destroy: true

  has_attached_file :image,
    :styles =>{
      },
    :storage => :s3,
    :bucket => 'dreamfunded',
    :path => "companies/:filename",
    :url =>':s3_domain_url',
    :s3_protocol => :https,
    :s3_credentials => {
      :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
      :secret_access_key => "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"
    }

  has_attached_file :document,
    :storage => :s3,
    :bucket => 'dreamfunded',
    :path => "documents/:filename",
    :url =>':s3_domain_url',
    :s3_credentials => {
      :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
      :secret_access_key => "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"
    }

  has_attached_file :cover,
    :styles =>{
      small: "360x",
      large: "900x"
      },
    :storage => :s3,
    :bucket => 'dreamfunded',
    :path => "cover-photos/:filename",
    :url =>':s3_domain_url',
    :s3_protocol => :https,
    :s3_credentials => {
      :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
      :secret_access_key => "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"
    }

  validates_attachment_size :cover, :less_than => 5.megabytes
  validates_attachment_size :image, :less_than => 5.megabytes
   validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates :goal_amount, numericality: { less_than_or_equal_to: 1000000 }
  validates_attachment_content_type :document, :content_type =>['application/pdf']

  scope :all_accredited, -> {
    order(:position).where(hidden: false, accredited: true).where.not(status: 3)
  }


  scope :with_followers, Proc.new {|user|
    select('DISTINCT(companies.id), companies.*, (followers.id IS NOT NULL) as followed_by_current_user').
      joins("LEFT JOIN followers ON companies.id = followers.company_id AND followers.user_id = #{user.id}") # this is an id so this should be safe
  }

  def self.Status
		{
			:Coming_Soon => 1,
			:Active => 2,
			:Funded => 3,
		}
	end

  before_create do
    self.end_date = Date.today unless self.end_date
  end

	def get_status
		if self.status == 1
			"Coming Soon"
		elsif self.status == 2
			"Active"
		elsif self.status == 3
			"Funded"
		end
	end

	def total_shares
		 liquidate_shares.pluck(:number_shares).sum
	end

  def average_share_price
    if total_shares > 0
     liquidate_shares.pluck(:shares_price, :number_shares).map!{|a| a[0]*a[1]}.sum / liquidate_shares.pluck(:number_shares).sum
    end
  end

  def left_days
    if end_date == nil
      return ' '
    end
    days_left = (end_date -  Date.today).to_i
    days_left = ' ' if days_left <= 0
    days_left
  end

  def invested
    investments.pluck(:invested_amount).sum
  end

  def fund_america_invested_amount
    if !self.fund_america_code.empty?
        offering_code = self.fund_america_code.split(':').second
        begin
         p "PULLING FundAmerica API"
         p offering_code
          offering = FundAmerica::Offering.details(offering_code)
          return  offering["funds_in_escrow"]
        rescue JSON::ParserError => e
          puts e
          puts 'ERROR'
          return invested_amount
        rescue FundAmerica::Error => e
          # Print response from FundAmerica API in case of unsuccessful response
          puts e.parsed_response
        else
          invested_amount
        end
    else
        invested_amount
    end
  end

  def offering_code
    self.fund_america_code.split(':').second
  end
end
