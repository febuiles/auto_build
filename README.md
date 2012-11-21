AutoBuild
=========

Automatically initialize associations in your Rails 3 models.

What
----
AutoBuild gives your models the option to automatically initialize (build) their
associations. This is useful to skip the `build_association` or `record.association.build` calls in
your models, controllers or views when working with nested fields.

Installation
----
Add `auto_build` to your Gemfile:

    gem "auto_build"

And run `bundle install`.

Usage
----

### has_one associations

Just call the `auto_build` method in your models:

     class User
       has_one :address
       has_one :phone

       auto_build :address
     end

With this in place, `address` will always be initialized, so you don't have to manually call
`build_address` anywhere. If the `User` already has an `address` assigned this won't overwrite it.

You can also do:

    auto_build :address, :phone,

To initialize several fields. One `after_initialize` callback will be created per association.

### belongs_to associations

Works the same as the `has_one` association:

     class User
       belongs_to :directory

       auto_build :directory
     end

### has_many associations

You can automatically initialize a `has_many` association in the same way you initialized a `has_one`
association:

    class User
      has_many :friends
      auto_build :friends
    end

    # User.new.friends.count == 1

The behavior will be the same, it will create a new `Friend` if none exists yet. If there's at least
one `Friend` in the collection then nothing will be created.

If you want to always append a new empty object at the end of the collection, you can pass the
`:append => true` option:

    class User
      has_many :friends
      auto_build :friends, :append => true
    end

    # count = some_user.friends.count
    # user = User.find(some_user.id)
    # user.friends.count == count + 1

This will always create a new `Friend` instance regardless of the value of `friends`. It
won't overwrite any existing values.

Finally, if you want to always bulk-add a number of records, you can pass the `:count` option with
the number of records you want to add:

    class User
      has_many :friends
      auto_build :friends, :count => 5
    end

    # count = some_user.friends.count
    # user = User.find(some_user.id)
    # user.friends.count == count + 5

This will always add 5 **extra** objects at the end of the collection. It won't overwrite any
existing values.

Notes
----
* **Watch out for fields with `reject_if`**. Since the AutoBuild callback will be added as an
  `after_initialize` hook this might overwrite the validations done in `reject_if`.
* The option `:append => true` is equivalent to `:count => 1`.
* None of the operations will overwrite existing objects.

Autobuilding associations means that if there's a value in the column, the object **will be loaded
every time you load the parent**. This is problematic if you're trying to optimize your code. To get
a better picture of this:

    class User
      has_one :address
      auto_build :address
    end

If you do `User.select(:id)` the resulting query will be `SELECT id FROM users;` **plus** `SELECT *
from addresses WHERE user_id = 42";`. This happens because we're calling calling `user#address`
every time we initialize a `User` object.

How it works
----
`auto_build` works by adding an `after_initialize` callback **per association** to your model.

Etc.
----
To report bugs or suggest new features go to the [Issues](https://github.com/febuiles/auto_build/issues)
tracker.

This was written by [Federico](http://mheroin.com). You can follow me on Twitter
[@febuiles](http://twitter.com/febuiles/). Let me know if you find this useful.
