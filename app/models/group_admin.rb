class GroupAdmin < ActiveRecord::Base

    belongs_to :group
    belongs_to :user


    has_attached_file :photo,
      :styles =>{
        thumbnail: "60x60^",
        small: "360x",
        large: "900x"
        },
      :storage => :s3,
      :bucket => 'dreamfunded',
      :path => '/:class/:style/:filename',
      :url =>':s3_domain_url',
      :s3_protocol => :https,
      convert_options: {
            thumbnail: " -gravity center -crop '200x200+0+0'",
      },
      :s3_credentials => {
        :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
        :secret_access_key => "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"
      }
    # validates_attachment_presence :photo
    validates_attachment_size :photo, :less_than => 2.megabytes
    validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
