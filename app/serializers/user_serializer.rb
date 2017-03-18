class UserSerializer < ApplicationSerializer
  attributes :id, :name, :first_name, :last_name, :login, :websites,
             :image_url, :bio, :aspirations, :achievements, :looking_for,
             :skills, :email, :phone, :verifications

  has_many :investments
  has_many :work_experiences
  has_many :educations

  def image_url
    @object.image.url
  end

  def verifications
    UserVerification.new(@object).to_json
  end

  def work_experiences
    @object.work_experiences.order('id DESC')
  end
end
