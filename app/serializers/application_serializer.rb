class ApplicationSerializer < ActiveModel::Serializer
  def to_json
    super.html_safe
  end
end