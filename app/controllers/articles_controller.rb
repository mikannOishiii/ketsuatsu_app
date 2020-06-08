class ArticlesController < ApplicationController
  def index
    @unread_articles = Post.published.unread_by(current_user)
    @read_articles = Post.published.read_by(current_user)
  end

  def show
    @article = Post.find(params[:id])
    @article.mark_as_read! for: current_user
  end
end
