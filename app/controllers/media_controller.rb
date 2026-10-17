class MediaController < ApplicationController
  def news
    @articles = Article.published.where(category: 'news')
  end

  def videos
    @category = params[:category]
    @videos = MediaVideo.order(created_at: :desc)
    @videos = @videos.where(category: @category) if @category.present?
  end
end
