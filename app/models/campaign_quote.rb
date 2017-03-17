class CampaignQuote < ActiveRecord::Base

  belongs_to :campaign
  validates :said_by, :main, presence: true


  ACCESSIBLE_ATTRIBUTES = [:id, :main, :description, :said_by, :position, :photo, :remote_image_url]



  has_attached_file :photo,
    :styles => { :thumb => "180x180#" },
    :storage => :s3,
    :bucket => 'dreamfunded',
    :path => "testimonials/:filename",
    :url =>':s3_domain_url',
    :s3_protocol => :https,
    :s3_credentials => {
      :access_key_id => "AKIAJWDE6UJS56MXQYPQ",
      :secret_access_key => "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"
    }

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates :said_by, :main, presence: true

  def photo_remote_url=(photo_remote_url)
    self.photo = URI.parse(photo_remote_url)
  end
end
