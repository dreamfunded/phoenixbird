class GroupsController < ApplicationController
  before_action :set_group, except: [:index, :new, :create, :add_to_group ]

  before_action :admin_check, except: [:show, :join_group, :add_to_group ]
  before_action :authenticate_user!, except: [:show, :add_to_group, :index ]


  def index
    @groups = Group.all
  end


  def show
    @posts = Post.order("created_at DESC").where(page: @group.slug)
    @admins = @group.group_admins
    @comments = @group.comments
    @companies = @group.companies
  end


  def new
    @group = Group.new
  end


  def edit
  end

  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join_group
    current_user.groups << @group
    ContactMailer.join_group_request(current_user, @group).deliver
    redirect_to @group, notice: "Request to join #{@group.name} was sent."
  end

  def add_admin_to_group
  end

  def add_group_admin
    user = User.find_by(email: params[:group_admin][:email])
    if user
      @admin = GroupAdmin.create(group_admin_params)
      @group.group_admins << @admin
      user.group_admin = @admin
      redirect_to @group
    else
      flash[:error] = 'Could not find user email. User needs to sign up first.'
      render :add_admin_to_group
    end
  end

  def add_to_group
    @invite = GroupInvite.find_by(token: params[:token])
    @group = Group.find(@invite.group_id )
    user = User.find_by(email: @invite.email)
    if user
      user.groups << @group
      redirect_to @group
    else
       redirect_to new_user_registration_path
    end
  end


  def group_members
  end

  def group_companies
    @companies = Company.all_accredited
    @my_companies = @group.companies
  end

  def endorse_company
    @company = Company.find(params[:company_id])
    @group.companies << @company
    redirect_to @group
  end

  def delete_endorsed_company
    @company = Company.find(params[:company_id])
    @group.companies.delete(@company)
    redirect_to @group
  end

  def delete_group_admin
    @group_admin = GroupAdmin.find(params[:admin_id])
    @group.group_admins.delete(@group_admin)
    redirect_to @group
  end

  def delete_group_member
    @user = User.find(params[:user_id])
    @group.users.delete(@user)
    redirect_to @group
  end



  private

    def set_group
      @group = Group.friendly.find(params[:id])
    end


    def group_params
      params.require(:group).permit(:name, :description, :image, :background, :member )
    end

    def group_admin_params
      params.require(:group_admin).permit(:name, :photo, :bio, :group_id, :user_id, :email)
    end

    def admin_check
      if current_user != nil && current_user.authority < User.Authority[:Editor]
        redirect_to url_for(:controller => 'home', :action => 'unauthorized')
      end
    end
end
