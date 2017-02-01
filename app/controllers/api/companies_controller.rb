class Api::CompaniesController < ApplicationController
  respond_to :json
  before_action :set_company, only: [:follow, :unfollow]

  def follow
    @company.followers.build(user: current_user)
    @company.save
  end

  def unfollow
    follower = @company.followers.find_by_user_id(current_user.id)
    follower.destroy
  end

  private

    def set_company
      @company = Company.find(params[:id])
    end
end