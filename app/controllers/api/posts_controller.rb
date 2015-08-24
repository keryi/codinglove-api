module Api
  class PostsController < ApplicationController
    def show
      @post = Post.find(params[:id])
      render json: @post
    end

    def random
      @post = Post.order('RANDOM()').first
      render json: @post
    end
  end
end
