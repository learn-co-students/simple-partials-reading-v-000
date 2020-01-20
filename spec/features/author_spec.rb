require 'rails_helper'

describe 'author show page' do
  before do
    @author = Author.create(name: "J.K. Rowling", hometown: "Killiechassie, Scotland")
  end

  it 'returns a 200 status code' do
    visit "/authors/#{@author.id}"
    expect(page.status_code).to eq(200)
  end

  it "shows the author's name and hometown" do
    visit "/authors/#{@author.id}"
    expect(page).to have_content(@author.name)
    expect(page).to have_content(@author.hometown)
  end
end
