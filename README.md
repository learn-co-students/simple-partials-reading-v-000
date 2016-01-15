## Objectives
1. Understand why partails are used.
2. Use rails's `render` method to do create a partial
3. Understand how a name of a partial turns into it's filename
4. Understand how to reference partials from an external folder

## Introduction

As you know, while coding we are generally trying to not repeat our code.  If we see a repeated chunk of code in different methods, we sometimes extract that chunk of code into its own method, which we can than reference in multiple places.

We can apply a similar tool to reduce repetition in html.  Partials are view-level files, that only form one part of an html page (get it? part, partial??).  By using a partial, we can remove repeated pieces of html, and add better organization to the code in our views.  

Let's look at an example to see what this means.

## Example

Take a look at the code used in the [form for on edit readme](https://github.com/learn-co-curriculum/rails-form_for-on-edit-readme).  

This is the code in the new form app/views/posts/new.html.erb
```
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
  <%= text_field_tag :title, @post.title %><br>

  <label>Post Description</label><br>
  <%= text_area_tag :description, @post.description %><br>

  <%= submit_tag "Submit Post" %>
<% end %>
```
Oh man, except for the first line of the form, it's like twinsies!  The labels and field tags are all the same.  Yea, so all of that duplication is not good in code.  Duplication means twice the amount of code to maintain, twice the opportunity for bugs, and two differing forms where our interface should be consistent.  Let's get rid of the duplicated code.

So instead of duplicating all of that code, we just want to write that code once in a file that contains all of that code (our partial) and call it from both our edit and show files. Here's how:

1. Create a new file in the `app/views/posts/` called `_form.html.erb`
To demarcate that this file is a partial, and only part of a larger view, we precede the filename with an underscore.
2. Remove the duplicated code from the `app/views/posts/edit.html.erb` and the `app/views/posts/new.html.erb` files and place it in the `app/views/posts/_form.html.erb` file.
3. Render the code into the posts/edit and posts/new pages by using placing `<%= render "form" %>` where we want the code in the partial to be rendered.  Notice that while the file name of our partial starts with an underscore, when we reference our partial there is no underscore.  

So now our posts/new, posts/edit, and posts/form files should look like the following:
`app/views/posts/new.html.erb`
```
<%= form_tag posts_path do %>
  <%= render 'form' %>
  <%= submit_tag "Submit Post" %>
<% end %>
```

`app/views/posts/edit.html.erb`
```
<h3>Post Form</h3>

<%= form_tag post_path(@post), method: "put" do %>
  <%= render 'form' %>
  <%= submit_tag "Edit Post" %>
<% end %>
```


`app/views/posts/_form.html.erb`
```
<label>Post title:</label><br>
<%= text_field_tag :title, @post.title %><br>

<label>Post Description</label><br>
<%= text_area_tag :description, @post.description %><br>
```

Ok - all done!

Just a couple of things to note.
1. Notice that even though the last line of the form, the `<% end %>` tag, is duplicated code, I didn't move it into my partial.  The reason for this is because it closes the beginning of the form_tag block, which DOES differ from form to form.  So I didn't like the idea of our form_tag block opening in one file, and close in a different file.  This is a stylistic point that you will get a feel for over time.

2. I could have named the partial whatever I want.  The only requirement is that it start with an underscore, and then reference that partial without the underscore.  But just like method names, it's good to make the names of our partials as semantic as possible.

3. I was able to reference the partial by just calling `<%= render 'form' %>`.  Notice that I didn't specify the folder that my partial lived in like `<%= render 'posts/form' %>`.  The reason I didn't need this (while it would have worked if I did include it), is because both my `posts/new` and my `posts/edit` files are referencing a partial from the same folder they live in, the `app/views/posts` folder.  When referencing a partial from a different folder, we must include the folder name as well (eg. `<%= render 'posts/form' %>` as opposed to just `<%= render 'form' %>`).


Note to Curriculum team.  I am unclear of the learning goals of this last part.  If the point is to show referencing partials from outside files, we can just reference a post, in an author's view which feels more intuitive to me.  Or we can say we want to allow users to create post from the welcome page as well.  Currently we don't have any category model, or controller.  So seems easier ways to get this point across.
 * Create a category display partial and put it in the category folder. Display it via the posts show action. Make sure you are just using the instance variables. It's going to feel icky

<a href='https://learn.co/lessons/simple-partials-reading' data-visibility='hidden'>View this lesson on Learn.co</a>
