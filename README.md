## Objectives

1. Explain why partials are used.
2. Use rails's `render` method to render a partial
3. Describe how the name of a partial turns into it's filename
4. Reference partials located in an external folder

## Introduction

As you know, while coding we are generally trying to not repeat our code.  If we see a repeated chunk of code in different methods, we sometimes extract that chunk of code into its own method, which we can than reference in multiple places.

We can apply a similar tool to reduce repetition in html.  Partials are view-level files, that only form one part of an html page (get it? part, partial??).  By using a partial we can remove repeated pieces of html and add better organization to the code in our views.  

Let's look at an example to see what this means.

## Example

Before we get started, make sure that you run `rake db:seed` to seed the database. This will give us some posts and authors. Because we want to focus on partials, you'll notice some hard-coding in the controller. In the Posts controller create action, we've hard-coded that every new post created is linked to the very first author in the database. 
 
Ok, let's dive in!

This is the code in the new form app/views/posts/new.html.erb
```erb
<%= form_tag posts_path do %>
  <label>Post title:</label><br>
  <%= text_field_tag :title %><br>

  <label>Post Description</label><br>
  <%= text_area_tag :description %><br>

  <%= submit_tag "Submit Post" %>
<% end %>
```
And this is the code in the edit file app/views/posts/edit.html.erb

```erb
<h3>Post Form</h3>

<%= form_tag post_path(@post), method: "put" do %>
  <label>Post title:</label><br>
  <%= text_field_tag :title %><br>

  <label>Post Description</label><br>
  <%= text_area_tag :description %><br>

  <%= submit_tag "Submit Post" %>
<% end %>
```
Except for the first line of the form, the code is pretty much the same!  The labels and field tags are the same.  All of that duplication is not good in code. Duplication means twice the amount of code to maintain, twice the opportunity for bugs, and two differing forms where our interface should be consistent.

Instead of duplicating all of that code, we just want to write that code once in a file that contains all of that code (our partial) and call it from both our edit and show files. Here's how:

First, let's create a new file in the `app/views/posts/` called `_form.html.erb`
To demarcate that this file is a partial, and only part of a larger view, we precede the filename with an underscore.

Second, let's remove the repeated code in `app/views/posts/edit.html.erb` so now the file should look like:

```erb
<h3>Post Form</h3>

<%= form_tag post_path(@post), method: "put" do %>
<% end %>
```
Note that we left in the non-duplicated code.  Now, let's also remove the duplicated code in the
`app/views/posts/new.html.erb` file.  Now this file should look like:

```erb
<%= form_tag posts_path do %>
<% end %>
```
So once again, we left the code that is particular to the view, and we removed the code inside the form_tag block, as that code is duplicated.

So now what?  It looks like we are missing a bunch of code in our 'posts/new' and 'posts/edit' files.  Not to worry, that's where our partial comes in handy.  

First, we'll place the duplicated code in a new file called `app/views/posts/_form.html.erb`. The file should look like the following:
`app/views/posts/_form.html.erb`
```erb
  <label>Post title:</label><br>
  <%= text_field_tag :title %><br>

  <label>Post Description</label><br>
  <%= text_area_tag :description %><br>

  <%= submit_tag "Submit Post" %>
```
Now we need to render the code into the posts/edit and posts/new pages by placing `<%= render "form" %>` where we want the code in the partial to be rendered.  Notice that while the file name of our partial starts with an underscore, when we reference our partial there is no underscore.  

So now our posts/new file should look like this:
`app/views/posts/new.html.erb`
```erb
<%= form_tag posts_path do %>
  <%= render 'form' %>
<% end %>
```

And our posts/edit file should look like this:
`app/views/posts/edit.html.erb`
```erb
<h3>Post Form</h3>

<%= form_tag post_path(@post), method: "put" do %>
  <%= render 'form' %>
<% end %>
```

Finally, our partial, the posts/form file looks like the following:
`app/views/posts/_form.html.erb`
```erb
<label>Post title:</label><br>
<%= text_field_tag :title %><br>

<label>Post Description</label><br>
<%= text_area_tag :description %><br>

<%= submit_tag "Submit Post" %>
```

Ok - all done!

Just a couple of things to note.
1. Notice that even though the last line of the form, the `<% end %>` tag, is duplicated code, we didn't move it into the partial.  The reason for this is because it closes the beginning of the form_tag block, which DOES differ from form to form.  So we didn't want to open our form_tag block in one file, and close in a different file.  This is a stylistic point that you will get a feel for over time.

2. We could have named the partial whatever we wanted to.  The only requirement is that it start with an underscore, and then reference that partial without the underscore.  But just like method names, it's good to make the names of our partials as semantic as possible.

3. We were able to reference the partial by just calling `<%= render 'form' %>`.  Notice that we didn't specify the folder that my partial lived in like `<%= render 'posts/form' %>`.  The reason we didn't need this (while it would have worked if we did include it), is because both my `posts/new` and my `posts/edit` files are referencing a partial from the same folder they live in, the `app/views/posts` folder.  When referencing a partial from a different folder, we must include the folder name as well (eg. `<%= render 'posts/form' %>` as opposed to just `<%= render 'form' %>`).

Let's do this now.  

## Rendering a partial from a different folder

Let's take a look at our `authors/show.html.erb` file.

```erb
<%= @author.name %>
<%= @author.hometown %>
```

And now look at the code in `posts/show.html.erb`

```erb
<%= @post.author.name %>
<%= @post.author.hometown %>

<h1><%= @post.title %></h1>
<p><%= @post.description %></p>
```

See the repetition?  In both places we are using the author object to call the name and hometown methods.  The first thing we have to fix is the slight difference between the templates.  Let's make the beginning portion of the posts show template match the authors show template.

`posts/show.html.erb`

```erb
<%= @author.name %>
<%= @author.hometown %>

<h1><%= @post.title %></h1>
<p><%= @post.description %></p>
```

Then let's make a new partial called `app/views/authors/_author.html.erb` and place the repeated code in the
file so that it looks like the following:

`app/views/authors/_author.html.erb`
```erb
<%= @author.name %>
<%= @author.hometown %>
```

Now we can just render this partial in our authors/show page by doing the following:

`app/views/authors/show.html.erb`
```erb
<%= render 'author' %>
```

We can make the same change in `app/views/posts/show.html.erb`


`app/views/posts/show.html.erb`
```erb
<%= render 'author' %>

<h1><%= @post.title %></h1>
<p><%= @post.description %></p>
```

Uh oh.  This won't work, because if we don't specify the folder name, rails will assume that the partial lives in the same folder as the view that is calling that partial.  In this case, it looks for a file in the posts directory called `_author.html.erb` and doesn't find it.  So we need to tell rails to go outside the folder, by being explicit about the folder and file name that it is rendering.  We do that by changing the code to the following:

`app/views/posts/show.html.erb`
```erb
<%= render 'authors/author' %>

<h1><%= @post.title %></h1>
<p><%= @post.description %></p>
```

We're almost there!  One more problem is that our partial assumes there is an instance variable called @author.  It needs it to work!  We'll need to change the posts controller to have it set an instance variable called @author.

Change the `posts#show` action in the controller to look like the following:

`app/controllers/posts_controller.rb`
```ruby
  def show
    @post = Post.find(params[:id])
    @author = @post.author
  end
```

And now we are done! Whew!

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/simple-partials-reading' title='Objectives'>Objectives</a> on Learn.co and start learning to code for free.</p>

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/simple-partials-reading'>Simple Partials </a> on Learn.co and start learning to code for free.</p>
