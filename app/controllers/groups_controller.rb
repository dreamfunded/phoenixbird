class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :join_group, :add_group_admin, :group_admin]
  before_action :admin_check, except: [:show, :join_group, :add_to_group ]
  before_action :authenticate_user!, except: [:show, :add_to_group, :index ]


  def index
    @groups = Group.all
  end


  def show
    @posts = Post.order(:created_at).where(page: @group.slug)
    @admins = @group.group_admins
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
    ContactMailer.delay.join_group_request(current_user, @group)
    redirect_to @group, notice: "Request to join #{@group.name} was sent."
  end

  def add_admin_to_group
    @group_admin  = GroupAdmin.new
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


  def add_group_admin
    @admin = GroupAdmin.create(group_admin_params)
    @group.group_admins << @admin
    redirect_to @group
  end

  private

    def set_group
      @group = Group.friendly.find(params[:id])
    end


    def group_params
      params.require(:group).permit(:name, :description, :image, :background, :members)
    end

    def group_admin_params
      params.require(:group_admin).permit(:name, :photo, :bio, :group_id)
    end

    def admin_check
      if current_user != nil && current_user.authority < User.Authority[:Editor]
        redirect_to url_for(:controller => 'home', :action => 'unauthorized')
      end
    end
end
