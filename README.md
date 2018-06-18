# AuthTrail

Track Devise login activity

:tangerine: Battle-tested at [Instacart](https://www.instacart.com/opensource)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'authtrail'
```

And run:

```sh
rails generate authtrail:install
rake db:migrate
```

## How It Works

A `LoginActivity` record is created every time a user tries to login. You can then use this information to detect suspicious behavior. Data includes:

- `scope` - Devise scope
- `strategy` - `database_authenticatable` for password logins, `rememberable` for remember me cookie, or the name of the OmniAuth strategy
- `identity` - email address
- `success` - whether the login succeeded
- `failure_reason` - if the login failed
- `user` - the user if the login succeeded
- `context` - controller and action
- `ip` - IP address
- `user_agent` and `referrer` - from browser
- `city`, `region`, and `country` - from IP
- `created_at` - time of event

IP geocoding is performed in a background job so it doesn’t slow down web requests. You can disable it entirely with:

```ruby
AuthTrail.geocode = false
```

## Features

Exclude certain attempts from tracking - useful if you run acceptance tests

```ruby
AuthTrail.exclude_method = proc do |info|
  info[:identity] == "capybara@example.org"
end
```

Write data somewhere other than the `login_activities` table.

```ruby
AuthTrail.track_method = proc do |info|
  # code
end
```

Set job queue for geocoding

```ruby
AuthTrail::GeocodeJob.queue_as :low
```

## Other Notes

We recommend using this in addition to Devise’s `Lockable` module and [Rack::Attack](https://github.com/kickstarter/rack-attack).

Works with Rails 5+

### Working with Rails 4

In order to get the code working in rails 4 the following class need to be defined:

```
class ApplicationJob
  include Sidekiq::Worker

  def self.perform_later(*args)
    perform_async(*args)
  end
end
```

```
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
```

and remove the `, optional: true` from the generated model. 

## History

View the [changelog](https://github.com/ankane/authtrail/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/authtrail/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/authtrail/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
