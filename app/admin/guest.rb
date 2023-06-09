ActiveAdmin.register Guest  do
  menu label: "Waitlist"
  controller do
    before_filter :authenticate

    private
    def authenticate
      if current_user.authority != authority[:Admin]
        redirect_to root_path
      end
    end

  end

  batch_action :example_action, form: {
                                              comment: :text,
                                              comment: :select,
                                              send_now: :checkbox
                                            } do |ids, inputs|
    # load selected trips
    guests = Guest.find(ids) # selected trips
    guests.update_all()
    redirect_to admin_guests_path
  end

# config.filters = false
filter :company, as: 'select', collection: proc { Company.all_accredited.pluck(:name) }

permit_params  :user_id, :email, :name, :created_at, :updated_at


  index :title => 'Waitlist' do
    selectable_column
    column "id"
    column  "name"
    column  "email"
    column("User") { |guest| link_to(guest.user.name, admin_user_path(guest.user)) if guest.user}
    column  "com pany"
    column  "created_at"
    actions
  end

  csv do
     column  "company"
     column("User") {|guest| guest.user.first_name if guest.user }
     column :email
     column("Phone") {|guest| guest.user.phone if guest.user }
   end


end
