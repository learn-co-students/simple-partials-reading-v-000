class PostsController < ApplicationController

=begin
  #_form.html.erb
  # a partial (and only part of a larger view), an underscore is prefixed to the filename.
  #created to cut down on repeating code

  <label>Post title:</label><br>
  <%= text_field_tag :title, @post.title %><br>

  <label>Post Description</label><br>
  <%= text_area_tag :description, @post.description %><br>
  
  <%= submit_tag "Submit Post" %>
  
=end  
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
=begin
 #show.html.erb
 <%= render 'authors/author' %> #added in order to to make call partial _author.html.erb .
=end
    @author = @post.author #added in order to make show.html.erb work.
  end

  def new
    @post = Post.new
=begin
 <%= render 'form' %> #added to call partial _form.html.erb

 <%= form_tag post_path(@post), method: "put" do %>
  <label>Post title:</label><br>
  <%= text_field_tag :title %><br>
 
  <label>Post Description</label><br>
  <%= text_area_tag :description %><br>
 
  <%= submit_tag "Submit Post" %>
  #removed repititive code
=end
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