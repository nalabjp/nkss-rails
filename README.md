nkss-rails with Slim
====================

This repository is the customized [nkss-rails](https://github.com/nadarei/nkss-rails).

In this repository you have to use the slim instead of haml.

__Thanks to [Rico Sta. Cruz](https://github.com/rstacruz) and [Nadarei Co.](https://github.com/nadarei) for original development.__

Nadarei KSS
===========

**Nadarei KSS Styleguides** lets you create pretty styleguides for your Rails
3.2 or higher projects.

![Image](https://raw.github.com/nadarei/nkss-rails/misc/sample.jpg)

[See more screenshots here.](https://github.com/nadarei/nkss-rails/tree/misc)

What is KSS?
------------

It's a standard for documenting stylesheets. It's also a tool that parses these
sheets, which `nkss-rails` uses.

See the KSS website at [warpspire.com/kss](http://warpspire.com/kss).

### What is nkss-rails?

A drop-in, easy-to-use, gorgeous-by-default Rails plugin you can put into your
projects so you can instantly have cute docs.

It's a pre-configured distribution of KSS. I've already done the grunt work for
you, like setting up the layouts, templates and CSS files for your styleguide.
All you gotta worry about is documenting your styles!

Installation
------------

Add me, and `slim`, to your `Gemfile`.

~~~ ruby
gem 'slim'
gem 'nkss-rails', github: 'nalabjp/nkss-rails'
~~~

Then type `bundle` to update your bundle. Then, install the needed files into
your project:

~~~ shell
$ bundle exec rails g nkss:install
~~~

Now move on to the next section.

### Customization

This gives you the following things that you should customize:

* __config/styleguides.yml__  
A list of sections in your styleguide. Your
mission: edit this file to add your own sections.

* __app/views/styleguides/__  
Your styleguides live here. Your mission:
edit the first styleguide (*1.html.slim*) and later, add your own.

* __app/views/layouts/styleguide.html.slim__  
The layout for your styleguide. Your mission: make sure that this loads the
right styles and scripts that your
application uses.

* __app/assets/stylesheets/example-for-styleguides.css__ (optional)  
An example of a documented KSS block. Study it, then delete it.

### Viewing your sheets

Now visit `http://localhost:8000/styleguides`. It should work straight away. By
default, it's only enabled in development mode.

This works because you have a new route added to your app that mounts the Nkss
engine to that path:

    Rails.application.routes.draw do
      ...
      mount Nkss::Engine => '/styleguides'  if Rails.env.development?
      ...
    end

How to document your styles
---------------------------

When you do the process above, you should already have an example in
`app/assets/stylesheets/example-for-styleguides.css`. But here's how to do it,
anyway...

### Document your CSS

In your CSS file, add a KSS document block. In this example, we'll define
section `1.3`. Refer to the [KSS Syntax](http://warpspire.com/kss/syntax/) page 
for more info.

~~~ css
/*
 * Buttons (.button):
 * A button for doing things.
 *
 * Styleguide 1.3.
 */

.button {
  color: red
}
~~~

The format for the first line is `name (code):`, where `name` describes the 
section you want to document, and `code` describes the CSS selector of it.

### Add the markup

Add the markup in the corresponding section in
`app/views/styleguides/N.html.slim`, where `N` is the main section number. In
this case, we'll be editing `1.html.slim`.

~~~ slim
-# 1.html.slim
= kss_block '1.3' do
  a.button href='#' Do things
~~~

### For new main sections

If you're adding a new main section, edit the file `config/styleguides.yml` to
add it to the menu.

~~~ yml
# config/styleguides.yml
title: My Site
sections:
  1: Buttons
  2: Forms
  3: Ratings
  4: ...
~~~

### That's it!

You should see your newly-documented style in
`http://localhost:8000/styleguides/1`.

Using in production
-------------------

Just make sure to add `styleguide.css` to your
precompilation list. Usually this is in `config/environments/production.rb`.

Acknowledgements
----------------

2012, MIT License.
