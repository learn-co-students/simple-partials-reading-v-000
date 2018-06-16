class PostsController < ApplicationController

  def index
    @authors = Author.all

    # filter the @posts list based on user input
    if !params[:author].blank?
      @posts = Post.by_author(params[:author])
    elsif !params[:date].blank?
      if params[:date] == "Today"
        @posts = Post.from_today
      else
        @posts = Post.old_news
      end
    else
      # if no filters are applied, show all posts
      @posts = Post.all
    end
  end

  def show
    @post = Post.find(params[:id])
    @author = @post.author
  end

  def new
    @post = Post.new
  end

  def create
    @author = Author.first
    @post = Post.new
    @post.title = params[:title]
    @post.description = params[:description]
    @post.author_id = @author.id
    @post.save
    redirect_to post_path(@post)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(title: params[:title], description: params[:description])
    redirect_to post_path(@post)
  end

end
