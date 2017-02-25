class Api::UsersController < Api::ResourceController
  before_action :set_user, only: [:show]
  def show
    respond_with @user, include: {investments: :company}
  end

  def update
    @user = current_user
    @user.update(user_params)
    respond_with @user
  end

  private

    def set_user
      @user = User.includes(investments: :company).find(params[:id])
    end

    def user_params
      params.require(:user).permit(*User::ACCESSIBLE_ATTRIBUTES)
    end
end
