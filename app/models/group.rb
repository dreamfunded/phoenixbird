class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_and_belongs_to_many :users
  has_many :group_admins

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

    has_attached_file :background,
      :styles =>{
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

        validates_attachment_size :background, :less_than => 5.megabytes
        validates_attachment_size :image, :less_than => 5.megabytes
        validates_attachment_content_type :background, content_type: /\Aimage\/.*\z/
        validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
