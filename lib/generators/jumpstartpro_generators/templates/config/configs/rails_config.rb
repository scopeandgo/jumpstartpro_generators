# frozen_string_literal: true

require "active_support/string_inquirer"
require "active_support/core_ext/object/blank"

class RailsConfig < ApplicationConfig
  attr_config :app_name,
    :log_to_stdout,
    :serve_static_files,
    :min_threads,
    :known_hostnames,
    max_threads: 5

  required :max_threads

  # copy railties/lib/rails.rb so that other config classes can use this check
  # since `Rails.env` isn't loaded yet when config classes are being run (often)
  def self.env
    @_env ||= ActiveSupport::StringInquirer.new(
      ENV["RAILS_ENV"].presence ||
      ENV["RACK_ENV"].presence ||
      "development"
    )
  end

  def app_name
    @app_name ||= super || File.basename(Rails.root).split("-").first
  end

  def database_name
    "#{app_name}_#{RailsConfig.env}"
  end

  def serve_static_files?
    serve_static_files.present?
  end

  def log_to_stdout?
    log_to_stdout.present?
  end

  def min_threads
    super || (self.min_threads = max_threads)
  end

  def known_hostnames
    super || []
  end
end
