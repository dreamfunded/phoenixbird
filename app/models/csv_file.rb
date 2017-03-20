class CsvFile < ActiveRecord::Base
    belongs_to :user
    #before_save :set_token

    has_attached_file :file,
      :styles =>{
        },
      :storage => :s3,
      :bucket => 'dreamfunded',
      :path => "csvfile/:id:filename",
      :url =>':s3_domain_url',
      :s3_protocol => :https,
      :s3_credentials => {
        :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
        :secret_access_key => "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"
      }

    validates_attachment_size :file, :less_than => 5.megabytes
    #validates_attachment_content_type :file, :content_type =>["text/csv", "text/comma-separated-values", "application/vnd.ms-excel"]
    validates_attachment_content_type :file, content_type: ['text/csv', "text/plain", 'text/comma-separated-values', 'application/csv', 'application/excel', 'application/vnd.ms-excel', 'application/vnd.msexcel']
end
