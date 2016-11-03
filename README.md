**This repo contains only the very draft for the task, described at [Cult of Martians][cultofmartians-task]. Feel free to use it on your own disposition**

[cultofmartians-task]: http://cultofmartians.com/tasks/rails-multibase-support.html

# DataBases

Supports usage of several databases in Rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'data_bases'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install data_bases
```

## Usage

Change `config/database.yml` so that settings for every database are placed under the following root key:

```yaml
# config/database.yml
---
base: # default key for the default database
  test:
    adapter: sqlite3
    url:     ./base/test.sqlite3
  development:
    adapter: sqlite3
    url:     ./base/development.sqlite3
  production:
    adapter: postgresql
    url:     <%= ENV['DEFAULT_BASE_URL'] %>
personal_data: # the unique name for another database
  test:
    adapter: sqlite3
    url:     ./personal_data/test.sqlite3
  development:
    adapter: sqlite3
    url:     ./personal_data/development.sqlite3
  production:
    adapter: postgresql
    url:     <%= ENV['PERSONAL_BASE_URL'] %>
medical_data:
  test:
    adapter: sqlite3
    url:     ./medical_data/test.sqlite3
  development:
    adapter: sqlite3
    url:     ./medical_data/development.sqlite3
  production:
    adapter: postgresql
    url:     <%= ENV['MEDICAL_BASE_URL'] %>
```

Run the gem's installer to generate abstract subclass of `ActiveRecord::Base` model for every database:

```shell
$ data_bases install
```

### Rails Generators

Use database-specific versions of generators for *models* and *migrations*.

#### Model

Add the name of database after the model's one (`profile:personal_data`):

```shell
$ rails g model profile:personal_data user_id:integer
```

This will create the abstract class `PersonalData` (if absent) with a base class for migrations:

```ruby
# app/models/personal_data.rb
class PersonalData < ActiveRecord::Base
  self.abstract_class = true

  establish_connection DataBases[:personal_data].current_settings

  class Migration < ActiveRecord::Migration
    def connection
      PersonalData.connection
    end
  end
end
```

The concrete model is inherited from abstract class:

```ruby
# app/models/profile.rb
class Profile < PersonalData
end
```

The migration is placed to a corresponding folder and inherited from the migration of the abstract class:

```ruby
# db/personal_data/migrate/20170117232307_create_profile.rb
class CreateProfile < PersonalData::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
```

#### Migration

Add the name of database after the migration (`create_profile:personal_data`). This will create a migration as in the example above.

```shell
$ rails g migration create_profile:personal_data user_id:integer
```
