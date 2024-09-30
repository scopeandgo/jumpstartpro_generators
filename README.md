# Jumpstart Pro Generators

When we start new client or internal projects we use [Jumpstart Pro](https://jumpstartrails.com/) and then sprinkle in our own initial gems, config, files, etc.

* [Anyway Config](https://github.com/palkan/anyway_config/) and some initial Config subclasses.
* `.cursorrules` for Cursor AI Editor
* Configuration for Rails Generators
* Tweaks to `bin/setup`
* Tweaks to `config/database.yml` and `config/cable.yml`
* Initial `db/seeds.rb` for creating staff seeds as admins

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
