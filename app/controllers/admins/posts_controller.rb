class Admins::PostsController < ApplicationController
  before_action :admin_user

  def index
    @posts = Post.all
  end

  def new
    @post = current_admin.posts.build
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
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
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

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
