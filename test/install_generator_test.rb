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
    run_generator
  end

  test "generates files" do
    assert_file "Gemfile", /anyway_config/

    assert_file "config/configs/application_config.rb"
    assert_file "config/configs/rails_config.rb"

    assert_file "config/initializers/generators.rb"

    assert_file ".cursorrules"

    # bin/setup should contain bin/rails db:schema:load db:seed
    assert_file "bin/setup", /bin\/rails db:schema:load db:seed/

    # db/seeds.rb should contain drnic@scopego.co
    assert_file "db/seeds.rb", /drnic@scopego.co/

    assert_file "README_JSP.md", /# 🎉 Jumpstart Pro Rails/
    assert_file "README.md", /# Rails app/

    # TODO:  run bin/setup && bin/rails test within destination root, it should not fail
  end
end
