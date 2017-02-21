class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def to_json(options={})
    new_serializer.to_json.html_safe
  end

  def as_json(options={})
    new_serializer.as_json
  end

  def active_model_serializer
    @active_model_serializer ||= "#{self.class.name}Serializer".constantize
  end

  private
    def new_serializer(options={})
      active_model_serializer.new(self, options)
    end
end