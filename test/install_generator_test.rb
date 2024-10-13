# frozen_string_literal: true

require "test_helper"
require "generators/jumpstartpro_generators/install_generator"

class JumpstartproGenerators::InstallGeneratorTest < ::Rails::Generators::TestCase
  include GeneratorTestHelpers

  class_attribute :install_destination

  tests JumpstartproGenerators::Generators::InstallGenerator
  destination File.join(tmp_path, "rails_app")

  remove_generator_sample_app
  create_generator_sample_app

  Minitest.after_run do
    # remove_generator_sample_app
    ENV.delete("BUNDLE_GEMFILE")
  end

  setup do
    ENV.update("BUNDLE_GEMFILE" => File.join(destination_root, "Gemfile"))
    system "cd #{destination_root} && bundle install"
    run_generator
  end

  test "generates files" do
    assert_file "Gemfile", /anyway_config/

    assert_file "config/configs/application_config.rb"
    assert_file "config/configs/rails_config.rb"

    assert_file "config/initializers/generators.rb"

    assert_file ".cursorrules"

    assert_file ".gitignore", /\.vscode/

    # bin/setup should contain bin/rails db:schema:load db:seed
    assert_file "bin/setup", /bin\/rails db:schema:load db:seed/

    # db/seeds.rb should contain drnic@scopego.co
    assert_file "db/seeds.rb", /drnic@scopego.co/

    assert_file "README_JSP.md", /# 🎉 Jumpstart Pro Rails/
    assert_file "README.md", /# Rails app/

    assert_file "config/environments/development.rb", /config.cache_store = :solid_cache_store/
    assert_file "config/environments/production.rb", /config.cache_store = :solid_cache_store/
    assert_file "config/cable.yml", /adapter: solid_cable/
    # TODO:  run bin/setup && bin/rails   test within destination root, it should not fail

    assert_file "Procfile", /worker: bin\/jobs/
    assert_file "Procfile.dev", /worker: bin\/jobs/

    # Service name should be dasherized
    assert_file "config/deploy.yml", /service: rails-app/
    # Image name should be dasherized
    assert_file "config/deploy.yml", /image: drnic\/rails-app/
    # Host should be dasherized
    assert_file "config/deploy.yml", /host: rails-app.client.scopego.co/
    # Database name should be underscore
    assert_file "config/deploy.yml", /POSTGRES_DB: rails_app_production/

    assert_file ".env", /POSTGRES_PASSWORD=/
    assert_file ".env", /KAMAL_REGISTRY_PASSWORD=/
  end
end
