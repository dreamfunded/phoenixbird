class Api::UsersController < Api::ResourceController
  before_action :set_user, only: [:show]
  def show
    respond_with @user, include: {investments: :company}
  end

  private

    def set_user
      @user = User.includes(investments: :company).find(params[:id])
    end
end
