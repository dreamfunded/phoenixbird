class PressPostsController < ApplicationController

  def index
    @press_posts = PressPost.all.order('date DESC')
  end

  def new
    @press_post = PressPost.new
  end

  def create
    @press_post = PressPost.new(press_post_params)

      if @press_post.save
        redirect_to press_path, notice: 'Member was successfully created.'
      else
        render :new
      end
  end

  def edit
    @press_post = PressPost.find(params[:id])
  end

  def update
    @press_post = PressPost.find(params[:id])
    if @press_post.update(press_post_params)
      redirect_to press_path
    else
      render :edit
    end
  end

  def destroy
    @press_post = PressPost.find(params[:id])
    @press_post.destroy
    respond_to do |format|
      format.html { redirect_to '/press', notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def press_post_params
      params.require(:press_post).permit(:date, :name, :url, :image, :quote)
  end
end
