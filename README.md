# `form_for` on Edit

If you know how to utilize the `form_tag` method for creating forms in Rails you may wonder why you need to learn a new form building process. Let's imagine that you've been tasked with creating the world's first pet hamster social network, and one of the requirements is that the hamster profile page needs to have about 100 different form fields that can be edited. If you are using the `form_for` method, your application will be technically resubmitting all 100 fields each time you edit the data. Your form view templates will also have 100 calls to the `@hamster` instance variable and each of the hamster attributes. Thankfully `form_for` is here and will help clean up the form view template and provide some additional benefits that we'll explore in this lesson.


## Recap of `form_tag`

To review, the `form_tag` helper method allows us to automatically generate HTML form code and integrate data to both auto fill the values as well as have the form submit data that the controller can use to either create or update a record in the database. It allows for you to pass in: the route for where the parameters for the form will be sent, the HTTP method that the form will utilize, and the attributes for each field.


## Issues with using `form_tag`

Before we get into the benefits and features of the `form_for` method, let's first discuss some of the key drawbacks to utilizing `form_tag`:

* Our form has to manually be passed the route for where the form parameters will be submitted

* The form has no knowledge of the form's goal, it doesn't know if the form is meant to create or update a record

* You're forced to have duplicate code throughout the form, it's hard to adhere to DRY principles when utilizing the `form_tag`


## Difference between `form_for` and `form_tag`

The differences between `form_for` and `form_tag` are subtle, but important, below is a basic breakdown of the differences, we'll start with talking about them at a high level perspective and then get into each one of the aspects on a practical/implementation basis:

* The `form_for` method accepts the instance of the model as an argument. Using this argument, `form_for` is able to make a bunch of assumptions for you.

* `form_for` yields an object of class `FormBuilder`

* `form_for` automatically knows the standard route (it follows RESTful conventions) for the form data as opposed to having to manually declare it

* `form_for` gives the option to dynamically change the `submit` button text (this comes in very handy when you're using a form partial and the `new` and `edit` pages will share the same form, but more on that in a later lesson)

A good rule of thumb for when to use one approach over the other is below:

* Use `form_for` when your form is directly connected to a model, extending our example from the introduction, this would be our Hamster's profile edit form that connects to the profile database table. This is the most common case when `form_for` is used

* User `form_tag` when you simply need an HTML form generated, examples of this would be: a search form field or a contact form


## Implementation of `form_for`

Let's take the `edit` form that utilized the `form_tag` that we built before for `posts` and refactor it to use `form_for`. As a refresher, here is the `form_tag` version:

```ERB
<% # app/views/posts/edit.html.erb %>
<h3>Post Form</h3>

<%= form_tag post_path(@post), method: "put" do %>
  <label>Post title:</label><br>
  <%= text_field_tag :title, @post.title %><br>

  <label>Post Description</label><br>
  <%= text_area_tag :description, @post.description %><br>
  
  <%= submit_tag "Submit Post" %>
<% end %>
```

Let's take this refactor one element at a time. Since we already have access to the `@post` instance variable we know that we can pass that to the `form_for` method, we also can remove the path argument and the `method` call, since `form_for` will automatically set these for us. How does `form_for` know that we want to use `PUT` for the form method? It's smart enough to know that since it's dealing with a pre-existing record that you want to utilize `PUT` over `POST`.

```ERB
<%= form_for(@post) do |f| %>
```

The `|f|` is an iterator variable that we can use on the new form object that will allow us to dynamically assign form field elements to each of the `post` data attributes, along with auto filling the values for each field. We get this `ActionView` functionality because we're using the `form_form` method and that gives us access to the `FormBuilder` module in Rails ([Documentation](http://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html)). Inside of the form we can now refactor the fields:

```ERB
<label>Post title:</label><br>
<%= f.text_field :title %><br>

<label>Post Description</label><br>
<%= f.text_area :description %><br>
```

Isn't that much cleaner? Notice how we no longer have to pass in the values manually? By passing in the attribute as a symbol (e.g. `:title`) that will automatically tell the form field what model attribute to be associated with, it also is what auto fills the values for us. Now let's refactor the submit button, instead of `<%= submit_tag "Submit Post" %>` we can change it to:

```ERB
<%= f.submit %>
```

Lastly, `form_for` also automatically sets the `authenticity_token` value for us, so we can remove the `<%= hidden_field_tag :authenticity_token, form_authenticity_token %>` line completely. Our new form will look something like this:

```ERB
<h3>Post Form</h3>

<%= form_for(@post) do |f| %>
  <label>Post title:</label><br>
  <%= f.text_field :title %><br>

  <label>Post Description</label><br>
  <%= f.text_area :description %><br>
  
  <%= f.submit %>
<% end %>
```

Our refactor work isn't quite done, if you had previously created a `PUT` route like we did in the `form_tag` lesson, we'll need to change that to a `PATCH` method since that is the HTTP verb that `form_for` utilizes, we can make that change in the `config/routes.rb` file:

```ruby
patch 'posts/:id', to: 'posts#update'
```

What's the difference between `PUT` and `PATCH`? The differences are pretty subtle, on a high level `PUT` has the ability to update the entire object, whereas `PATCH` simply updates the element that was changed. Many developers choose to utilize `PATCH` as much as possible because it requires less overhead, however it is pretty rare when you will need to distinguish between the two verbs and they are used interchangeably quite often.

You can also put in an additional argument if you're using the `resources` method for `update` and this will all happen automatically.

Now if you start the Rails server and go to an edit page you'll see that the data is loaded into the form and everything appears to be working properly, however if you change the value of one of the form fields and click `Update post` you will see that the record isn't updated. So what's happening? When I run into behavior like this I'll usually look at the console logs to see if it tells me anything. Below is the screenshot of what I see after submitting the form:

![Unpermitted Parameters](https://s3.amazonaws.com/flatiron-bucket/readme-lessons/unpermitted_params.png)

Because `form_for` is bound directly with the `Post` model, we need to pass the model into update method in the controller. So let's change: `@post.update(title: params[:title], description: params[:description])` to:

```ruby
@post.update(params.require(:post))
```

So why do we need to `require` the `post`? If you look at the old form the params would look something like this:

```
{
  "title": "My Title",
  "description": "My description"
}
```

With the new structure for the `form_for` the params look like this:

```
{
  "post": {
            "title": "My Title",
            "description": "My description"
          }
}
```

Notice how the attributes are now encapsulated in the `"post"` object? That's the main reason we needed to add the `require` method.

Now if you go back to the `edit` page and submit the form, the record will be updated in the dataabse sucessfully.


## Summary

Nice work, you now know how to integrate multiple form helpers into a Rails application and you should have a good idea on when to properly use `form_form` vs `form_tag`.