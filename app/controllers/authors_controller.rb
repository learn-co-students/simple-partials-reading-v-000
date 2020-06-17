class AuthorsController < ApplicationController
  def show
    @author = Author.find(params[:id])
    @author = @post.author
  end
end
