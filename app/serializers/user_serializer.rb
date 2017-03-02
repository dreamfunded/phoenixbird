class UserSerializer < ApplicationSerializer
  attributes :id, :name, :first_name, :last_name, :login, :websites,
             :image_url, :bio, :aspirations, :achievements, :looking_for,
             :skills

  has_many :investments

  def image_url
    @object.image.url
  end
end
