# Jumpstart Pro Generators

When we start new client or internal projects we use Rails 8, Solid Queue, and [Jumpstart Pro](https://jumpstartrails.com/) and then sprinkle in our own initial gems, config, files, etc.

* [Anyway Config](https://github.com/palkan/anyway_config/) and some initial Config subclasses.
* `.cursorrules` for Cursor AI Editor
* Configuration for Rails Generators (no jbuilder, helper tests)
* Add `annotate` and setup rake task
* Tweaks to `config/database.yml` and `config/cable.yml` for Solid Queue & Solid Cable
* Setup `config/deploy.yml` for Kamal2 deploy to our initial client shared server
* Defaults to Solid Queue in Puma; or uncomment `jobs:` for standalone jobs containers
* Initial `config/jumpstart.yml` with default business details
* Postgres password generated into credentials (if useful for kamal deploy)

## Usage

There is a one-line command [`bin/newrepo`](bin/newrepo) you can run to clone JumpstartPro, run the generators, setup, and run the tests:

```bash
curl -s https://raw.githubusercontent.com/scopeandgo/jumpstartpro_generators/refs/heads/develop/bin/newrepo | bash -s -- testapp --force
```

See [`bin/newrepo`](bin/newrepo) for optional flags that can be added/used instead of `--force` above.

For example, to use an alternate JSP repo, use the `--repo` flag:

```bash
curl -s https://raw.githubusercontent.com/scopeandgo/jumpstartpro_generators/refs/heads/develop/bin/newrepo | bash -s -- testapp --force --repo https://github.com/scopeandgo/jumpstart-pro.git
```

The `--repo` argument could also be a file path to a local git clone.

### Manual usage

Given the app name `testapp`:

```plain
git clone https://github.com/jumpstart-pro/jumpstart-pro-rails.git testapp
cd testapp

bundle add jumpstartpro_generators --github scopeandgo/jumpstartpro_generators
bin/rails generate jumpstartpro_generators:install
bundle remove jumpstartpro_generators || true

bin/setup
bin/rails test
```

### Output

The generator output might look like:

```plain
     gemfile  anyway_config
     gemfile  mission_control-jobs
         run  bundle install from "."
      append  Brewfile
       exist  config/initializers
      create  config/initializers/generators.rb
      create  .cursorrules
      append  .gitignore
        gsub  bin/setup
       force  db/seeds.rb
      create  README.md
      remove  config/environments/staging.rb
        gsub  config/environments/development.rb
      remove  config/recurring.yml
    generate  solid_queue:install
       rails  generate solid_queue:install
   identical  config/queue.yml
      create  config/recurring.yml
      create  db/queue_schema.rb
   identical  bin/jobs
        gsub  config/environments/production.rb
    generate  solid_cache:install
       rails  generate solid_cache:install
   identical  config/cache.yml
      create  db/cache_schema.rb
        gsub  config/environments/production.rb
    generate  solid_cable:install
       rails  generate solid_cable:install
      create  db/cable_schema.rb
       force  config/cable.yml
        gsub  config/environments/development.rb
        gsub  config/environments/production.rb
      append  Procfile
      append  Procfile.dev
      create  config/configs
      create  config/configs/application_config.rb
      create  config/configs/rails_config.rb
       force  config/database.yml
       force  config/cable.yml
       force  config/deploy.yml
      append  .kamal/secrets
      insert  lib/templates/rails/credentials/credentials.yml.tt
      create  .env
      create  config/jumpstart.yml
```

The created databases will be based on the base directory name, which is the appname `testapp` in example above:

* `testapp_development`
* `testapp_test`

The `bin/setup` also runs `rails db:seed` which adds `drnic@scopego.co` and other admin users. Edit `db/seeds.rb` to add more seed users.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Before making commits, install the git pre-commit hooks using `overcommit`, which will automatically lint your changes with `standardrb`:

```plain
overcommit
```

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/scopeandgo/jumpstartpro_generators>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/scopeandgo/jumpstartpro_generators/blob/develop/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jsp::Generators project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/scopeandgo/jumpstartpro_generators/blob/develop/CODE_OF_CONDUCT.md).
