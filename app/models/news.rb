class News < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

	validates :title, presence:true
	validates :content, presence:true
	validates :source, presence:true

  has_attached_file :image,
    :styles =>{
      },
    :storage => :s3,
    :bucket => 'dreamfunded',
    :path => "news/:filename",
    :url =>':s3_domain_url',
    :s3_protocol => :https,
    :s3_credentials => {
      :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
      :secret_access_key => "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"
    }
  # validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def previous_post
    self.class.where("id > ?", id).last
  end

  def next_post
     self.class.where("id < ?", id).last
  end



end
