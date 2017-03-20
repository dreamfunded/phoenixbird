class Event < ActiveRecord::Base
   has_attached_file :image,
     :styles =>{
        medium: "300x300>",
        small: "200x200>",
        thumb: "100x100>"
      },
     :storage => :s3,
     :bucket => 'dreamfunded',
     :path => "events/:filename",
     :url =>':s3_domain_url',
     :s3_protocol => :https,
     :s3_credentials => {
       :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
       :secret_access_key => "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"
     }

    validates_attachment_size :image, :less_than => 5.megabytes
    validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
