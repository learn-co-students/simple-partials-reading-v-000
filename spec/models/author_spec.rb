# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  name       :string
#  hometown   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Author, type: :model do
  it "has a name" do
    @author = Author.new
    @author.name = "Steven The Great!"

    expect(@author.name).to eq("Steven The Great!")
  end

    it "has a hometown" do
    @author = Author.new
    @author.hometown = "Chicago"

    expect(@author.hometown).to eq("Chicago")
  end
end
