# frozen_string_literal: true

require "test_helper"
require "generators/jumpstartpro_generators/install_generator"

class JumpstartProGenerators::InstallGeneratorTest < ::Rails::Generators::TestCase
  include GeneratorTestHelpers

  class_attribute :install_destination

  tests JumpstartProGenerators::Generators::InstallGenerator
  destination File.join(tmp_path, "rails_app")

  remove_generator_sample_app
  create_generator_sample_app

  Minitest.after_run do
    # remove_generator_sample_app
  end

  setup do
    run_generator
  end

  test "generates anyway_config files" do
    assert_file "config/configs/application_config.rb"
    assert_file "config/configs/rails_config.rb"
    assert_file "config/configs/redis_config.rb"
  end
end
