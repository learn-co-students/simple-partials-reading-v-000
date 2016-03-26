require "rails_helper" 

RSpec.describe AuthorsController, type: :controller do
  include Capybara::DSL
  render_views
  
  context "#show" do 
    it "uses the _author partial to display the author's name and hometown" do 
      @author = Author.create(name: "John Grisham", hometown: "Charlottesville, VA")
      visit author_path(@author)
      expect(page).to render_template(partial: "_author")
    end
  end
end

RSpec.describe PostsController, type: :controller do 
  include Capybara::DSL
  render_views 
  before do
    @author = Author.create(name: "John Grisham", hometown: "Charlottesville, VA")

    @post = Post.create(title: "A Time To Kill", description: "A Time to Kill is a 1989 legal suspense thriller by John Grisham. It was Grisham's first novel. The novel was rejected by many publishers before Wynwood Press (located in New York) eventually gave it a modest 5,000-copy printing. After The Firm, The Pelican Brief, and The Client became bestsellers, interest in A Time to Kill grew; the book was republished by Doubleday in hardcover and, later, by Dell Publishing in paperback, and itself became a bestseller. This made Grisham extremely popular among readers.", author_id: 1)
  end
  
  context "#show" do 
    it "uses the _author partial to display the auhtor's name and hometown" do 
      visit post_path(@post)
      expect(page).to render_template(partial: "authors/_author")
    end
  end
end