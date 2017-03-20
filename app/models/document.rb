class Document < ActiveRecord::Base
  belongs_to :company

  has_attached_file :file,
    :storage => :s3,
    :bucket => 'dreamfunded',
    :path => "documents/:filename",
    :url =>':s3_domain_url',
    :s3_protocol => :https,
    :s3_credentials => {
      :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
      :secret_access_key => "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"
    }
    validates_attachment_content_type :file, :content_type =>['application/pdf', "application/vnd.openxmlformats-officedocument.presentationml.presentation"]
end
