class WorkExperienceSerializer < ApplicationSerializer
  attributes :id, :company_name, :title

  def company_name
    @object.community_company.name
  end
end