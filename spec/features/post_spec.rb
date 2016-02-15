require 'rails_helper'

describe 'navigate' do
  before do
    @author = Author.create(name: "Bob", hometown: "USA")
    @post = Post.create(title: "My Post", description: "My post desc", author_id: @author.id)
  end

  it 'shows the title on the show page in a h1 tag' do
    visit "/posts/#{@post.id}"
    expect(page).to have_css("h1", text: "My Post")
  end

  it 'to post pages' do
    visit "/posts/#{@post.id}"
    expect(page.status_code).to eq(200)
  end

  it 'shows the description on the show page in a p tag' do
    visit "/posts/#{@post.id}"
    expect(page).to have_css("p", text: "My post desc")
  end
end
