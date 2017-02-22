class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :first_name, :image_url

  def image_url
    @object.image.url
  end
end
