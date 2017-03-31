ActiveAdmin.register GroupAdmin  do
  menu label: "Group Admin"
  controller do
    before_filter :authenticate

    private
    def authenticate
      if current_user.authority != authority[:Admin]
        redirect_to root_path
      end
    end

  end

# config.filters = false


permit_params  :user_id,  :name, :bio, :group_id, :photo, :email


  index :title => 'Group Admins' do
    column  "name"
    column("group") {|user| user.group.name }
    actions
  end

  form do |f|
    f.inputs 'User Details' do
      f.input   :name
      f.input   :email
      f.input   :bio
      f.input   :photo, :required => false, :as => :file
      f.input   :group
    end
    f.actions
  end

  show do |ad|
    attributes_table do
      row :name
      row :email
      row :bio
      row :group
      row :photo do
        image_tag(ad.photo.url)
      end

    end
   end


end
