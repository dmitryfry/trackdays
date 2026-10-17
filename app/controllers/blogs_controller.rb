class BlogsController < ApplicationController
  before_action :require_user, only: [:new, :create, :create_comment]

  def index
    @category = params[:category]
    @articles = Article.published
    @articles = @articles.by_category(@category) if @category.present?
  end

  def show
    @article = Article.find_by!(slug: params[:slug])
    @article.increment!(:views_count)
    @comment = Comment.new
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)
    @article.published_at = Time.current
    if @article.save
      redirect_to blog_post_path(@article.slug), notice: "Статья успешно опубликована в сообществе!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_comment
    @article = Article.find_by!(slug: params[:slug])
    @comment = @article.comments.build(body: params[:comment][:body], user: current_user)
    if @comment.save
      redirect_to blog_post_path(@article.slug), notice: "Комментарий опубликован!"
    else
      redirect_to blog_post_path(@article.slug), alert: "Текст комментария не может быть пустым."
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :category, :summary, :content, :cover_image_url)
  end
end
