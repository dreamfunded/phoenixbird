class User < ActiveRecord::Base
	before_create :set_authority
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	belongs_to :company
	has_and_belongs_to_many :groups


	has_many :investments
	has_many :comments
	has_many :guests
	has_many :invites
	has_many :csv_files
	has_many :liquidate_shares
	has_many :bids
	has_many :docusigns
	has_many :followers, inverse_of: :user
	has_many :followings, through: :followers, source: :company, inverse_of: :user_followers
	has_many :identities

	has_one :investor
	#Getter
	validates :first_name, presence:true
	validates :last_name, presence:true
	#validates_uniqueness_of :login
	#validates_uniqueness_of :email
	#validates :password, length: { in: 6..20 }
	validates :password, confirmation: true


	has_attached_file :image,
	  :styles =>{
	    },
	  :storage => :s3,
	  :bucket => 'dreamfunded',
	  :path => "users/:filename",
	  :url =>':s3_domain_url',
	  :s3_protocol => :https,
	  :s3_credentials => {
	    :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
	    :secret_access_key => "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"
	  }
	# validates_attachment_presence :image
	validates_attachment_size :image, :less_than => 5.megabytes
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


	def self.from_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	    user.provider = auth.provider
	    user.uid = auth.uid
	    user.email = auth.info.email
	    user.confirmed = true
	    user.first_name = auth.info.name.split(' ').first
	    user.last_name = auth.info.name.split(' ').second
	    user.password = Devise.friendly_token[0, 20]
	    user.authority = 2
	    #user.image_url = auth.info.image
	  end
	end

	def self.Authority
		{
			:Basic => 1,
			:Accredited => 2,
			:Editor => 3,
			:Admin => 4
		}
	end

	def set_authority
		self.authority = 2
	end

	def name
		first_name.capitalize + " " + last_name.capitalize
	end

	def comments_name
		first_name.capitalize + " " + last_name.capitalize.chars.first + "."
	end

	def my_campaign
		if self.company
			company = self.company
			campaign = company.campaign
			if campaign.submitted?
				company.name
			else
				if company.name
					"Finish #{company.name}"
				else
					"Finish Campaign"
				end
			end
		else
			"Get Funded"
		end
	end

	def make_founder
		self.update(role: 'founder')
	end

	def make_supporter
		self.update(role: "supporter")
	end

	def startup?
		return true if self.try(:company).try(:accredited)
		false
	end

	def has_company?
		return true if self.try(:company).try(:name?)
		false
	end

end
