class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
                    :storage => :s3,
                    :bucket => 'dreamfunded',
                    :path => "documents/:filename",
                    :url =>':s3_domain_url',
                    :s3_protocol => :https,
                    :s3_credentials => {
                           :access_key_id => "AKIAIX55AGQZA4VAPJYQ",
                          :secret_access_key => "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"
                    },
                    :styles => { :content => '800>' }

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 2.megabytes
  validates_attachment_content_type :data, :content_type => /\Aimage/

  def url_content
    url(:content)
  end
end
