class Testimonial < ActiveRecord::Base

  ACCESSIBLE_ATTRIBUTES = [:id, :name, :position, :photo, :message]

  belongs_to :campaign

  validates :name, :position, :message, presence: true

  has_attached_file :photo,
    :styles => { :thumb => "180x180#" },
    :storage => :s3,
    :bucket => 'dreamfunded',
    :path => "testimonials/:filename",
    :url =>':s3_domain_url',
    :s3_protocol => :https,
    :s3_credentials => {
      :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
      :secret_access_key => "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"
    }

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_size :photo, :less_than => 5.megabytes
end
