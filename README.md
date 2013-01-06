# Manhattan

Manhattan (based on the Watchmen character of Doctor Manhattan) is a gem extracted from the practices we used at [Xenda](http://xenda.pe "Xenda") in the development of our projects.

It strives to be a simple status manager for models with minimal overhead and allowing the creation of a simple state machine. Most projects in our experience need for a model to hold a status at once and to perform some actions before or after obtaining that state. This gem simplifies that work without adding much overhead.

## Installation

Add this line to your application's Gemfile:

    gem 'manhattan'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install manhattan

## Usage

Models that want to be handled by Manhattan should include the gem on their definition:

```ruby
class ComicBook < ActiveRecord::Base
  include Manhattan
end
```

Manhattan will then wait for your to describe the list of states your class can hold:

```ruby
class ComicBook < ActiveRecord::Base
  include Manhattan

  has_statuses :opened, :sold

end
```

For it to do its work, it'll assume the model has a "status" column of type string on your database. This can be customized by appending the "column_name" key at the end of your states list: 

```ruby
class ComicBook < ActiveRecord::Base
  include Manhattan

  has_statuses :opened, :sold, column_name: :state

end
```

Manhattan will even allow you to setup a default state for initialized records. Take notice that this shouldn't be used instead of setting a default value on a migration or directly on your column.

After this setup, Manhattan will give you some love in the form of code

#### Getting a list of status

```ruby
ComicBook.statuses        #=>  ["opened", "sold"]
ComicBook.new.statuses    #=>  ["opened", "sold"]
```

#### Setting a new status

```ruby
comic_book = ComicBook.new
comic_book.mark_as_opened
comic_book.status          #=>  "opened"
```

#### Querying about its status

```ruby
# directly asking for status
comic_book.opened?         #=> "true"
comic_book.sold?           #=> "false"

# or even asking about its negative
comic_book.unopened?       #=> "false"
comic_book.not_sold?       #=> "true"
```

Manhattan will create alias like "invalid" "unsold" and "not_valid" for each state. Use whichever feels natural for your code.

#### Performing actions before and after code changes

Manhattan will look for before_* and after_* methods for each state. If they exist, it will run them accordingly: 

```ruby
class ComicBook < ActiveRecord::Base
  # .... all the above code

  def before_opened
    puts "This is a sad day... when this comic loses its value"
  end

  def after_opened
    puts "WE CRY NOW AND SHIVER FOR IT'S NO LONGER COLLECTABLE"
  end
```

```ruby
comic_book.mark_as_opened  #=>
#"This is a sad day... when this comic loses its value"
#"WE CRY NOW AND SHIVER FOR IT'S NO LONGER COLLECTABLE"
````

#### Model scopes

Each model class has associated scopes created for easy returning records from the DB for each state:

```ruby
ComicBook.opened  #=>  select * from comic_books where status = 'opened'
```

#### Adding a default state

If wanted, you can setup a default state for your model

```ruby
class ComicBook < ActiveRecord::Base
  include Manhattan

  has_statuses :opened, :sold, default_value: :opened
end
```

```ruby
ComicBook.new.status #=>  "opened"
```

## TODO

Fairly simple, but I18N is pending.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request