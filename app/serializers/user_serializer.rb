class UserSerializer < ApplicationSerializer
  attributes :id, :name, :first_name, :image_url

  has_many :investments

  def image_url
    @object.image.url
  end
end
