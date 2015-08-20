class PostsController < ApplicationController
  def index
    @posts = Post.order('id desc').page(params[:page]).per(5)
    respond_to :html, :js
  end
end
