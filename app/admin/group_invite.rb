ActiveAdmin.register GroupInvite  do

  menu label: "Group Invite"

  controller do
    before_filter :authenticate

    private
    def authenticate
      if current_user.authority != authority[:Admin]
        redirect_to root_path
      end
    end
  end



end
