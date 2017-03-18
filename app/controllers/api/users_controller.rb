class Api::UsersController < Api::ResourceController
  before_action :set_user, only: [:show]
  def show
    # not really used currently
    respond_with @user, include: [:work_experiences, :educations, {investments: :company}]
  end

  def update_profile
    @user = current_user
    @user.update(user_params)
    respond_with @user
  end

  def check_identity
    @user = current_user
    @identity = @user.identities.find_by!(provider: params[:provider])
    respond_with @identity
  end

  def create_work_experience
    @work_experience = current_user.work_experiences.build(work_experience_params)
    @work_experience.save
    respond_with @work_experience
  end

  def destroy_work_experience
    @work_experience = current_user.work_experiences.find(params[:id])
    @work_experience.destroy
    respond_with @work_experience
  end

  def create_education
    @education = current_user.educations.build(education_params)
    @education.save
    respond_with @education
  end

  private

    def set_user
      @user = User.includes(investments: :company).find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        *User::ACCESSIBLE_ATTRIBUTES,
        work_experiences_attributes: WorkExperience::ACCESSIBLE_ATTRIBUTES)
    end

    def work_experience_params
      params.require(:work_experience).permit(
        *WorkExperience::ACCESSIBLE_ATTRIBUTES,
        community_company_attributes: CommunityCompany::ACCESSIBLE_ATTRIBUTES
        )
    end

    def education_params
      params.require(:education).permit(
        *Education::ACCESSIBLE_ATTRIBUTES,
        school_attributes: School::ACCESSIBLE_ATTRIBUTES
        )
    end
end
