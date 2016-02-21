# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

post1 = Post.create(title: "My Post", description: "My post desc")
post2 = Post.create(title: "My Post2", description: "My post desc2")
post3 = Post.create(title: "My Post3", description: "My post desc3")
author = Author.create(name: "John Doe", hometown: "New York")
author.posts << post1
author.posts << post2
author.posts << post3