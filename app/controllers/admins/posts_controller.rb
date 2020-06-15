class Admins::PostsController < ApplicationController
  before_action :admin_user
  PICTURE_COUNT = 3

  def index
    @posts = Post.all
  end

  def new
    @post = current_admin.posts.build
    PICTURE_COUNT.times { @post.pictures.build }
  end

  def create
    @post = current_admin.posts.build(post_params)
    if @post.save
      flash[:notice] = "記事を投稿しました！"
      redirect_to admins_dashboard_url
    else
      render action: :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    count = @post.pictures.count
    (PICTURE_COUNT - count).times { @post.pictures.build }
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(update_post_params)
      flash[:notice] = "記事を更新しました！"
      redirect_to admins_dashboard_url
    else
      render action: :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "記事を削除しました"
    redirect_to admins_dashboard_url
  end

  def status
    if params[:status] == "0"
      @posts = Post.all.draft
    elsif params[:status] == "1"
      @posts = Post.all.published
    elsif params[:status] == "2"
      @posts = Post.all.unpublished
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :status, pictures_attributes: [:name])
  end

  def update_post_params
    params.require(:post).permit(:title, :content, :status, pictures_attributes: [:name, :_destroy, :id])
  end
end
