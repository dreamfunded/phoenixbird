class EducationSerializer < ApplicationSerializer
  attributes :id, :school_name, :degree_type, :major,
             :achievements, :graduated_year, :graduated_month

  def school_name
    @object.school.name
  end
end