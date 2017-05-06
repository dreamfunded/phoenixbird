class Founder < ActiveRecord::Base
	belongs_to :company

	validates :name, presence:true
	# validates :image_address, presence:true
	validates :content, presence:true
	# validates :company_id, presence:true

  has_attached_file :image,
    :styles => { :thumb => "180x180#", :big => "500x500#"  },
    :storage => :s3,
    :bucket => 'dreamfunded',
    :path => "founders/:filename",
    :url =>':s3_domain_url',
    :s3_protocol => :https,
    :s3_credentials => {
      :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
      :secret_access_key => "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"
    }
  # validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

end
