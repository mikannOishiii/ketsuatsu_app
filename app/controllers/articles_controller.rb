class ArticlesController < ApplicationController
  def index
    @unread_articles = Post.unread_by(current_user)
    @read_articles = Post.read_by(current_user)
  end

  def show
    @article = Post.find(params[:id])
    @article.mark_as_read! for: current_user
  end
end
