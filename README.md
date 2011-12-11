AutoBuild
=========

Automatically initialize associations in your Rails models

What
----
AutoBuild gives your models the option to automatically initialize (build)
associations. This is useful to skip the `build_association` calls in your controllers when working
with nested fields (`fields_for`).

Right now it only supports `has_one` associations.

Installation
----
Add `auto_build` to your Gemfile:

    gem "autobuild"

And run `bundle install`.

Usage
----
Just call the `auto_build` method in your models:

     class User
       has_one :address
       auto_build :address
     end

With this in place, `address` will always be initialized, so you don't have to manually call
`build_address` anywhere.

How
----
`auto_build` works by adding an `after_initialize` hook to your model that build the association if
its current value is nil. It **will not** override existing values.

Etc.
----
Bugs, feature suggestions, etc. go to the [Issues](https://github.com/febuiles/auto_build/issues)
tracker.

This was written by [Federico](http://mheroin.com). You can follow me on Twitter
[@febuiles](http://twitter.com/febuiles/). Let me know if you find this useful.
