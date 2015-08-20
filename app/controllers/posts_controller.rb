class PostsController < ApplicationController
  def index
    @posts = Post.order('id desc').page(params[:page])
    respond_to :html, :js
  end
end
