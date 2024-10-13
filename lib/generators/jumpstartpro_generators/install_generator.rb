# frozen_string_literal: true

require "rails/generators"
require "fileutils"

module JumpstartproGenerators
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Install Scope & Go defaults into Jumpstart Pro"
      source_root File.join(File.dirname(__FILE__), "templates")

      def add_gemfile_entries
        %w[anyway_config solid_cache solid_queue solid_cable mission_control-jobs].each do |gem|
          unless File.read(File.join(destination_root, "Gemfile")).include?(gem)
            gem gem
          end
        end

        run "bundle install"
      end

      def add_brewfile_entries
        insert_into_file "Brewfile", "\nbrew \"yq\"\n"
      end

      def copy_initializers
        directory "config/initializers", "config/initializers"
      end

      def editor_settings
        copy_file ".cursorrules", ".cursorrules"
      end

      def gitignore
        insert_into_file ".gitignore", "\n.vscode\n"
      end

      def bin_setup_updates
        gsub_file "bin/setup", %(system! "bin/rails db:prepare"), <<-RUBY.strip
  system! "bin/rails db:drop db:create"
  system! "bin/rails db:schema:load db:seed"
        RUBY
      end

      def copy_seeds_file
        copy_file "db/seeds.rb", "db/seeds.rb", force: true
      end

      def move_readme_file
        move_file "README.md", "README_JSP.md"
        template "README.md.tt", "README.md"
      end

      def drop_staging_env
        remove_file "config/environments/staging.rb"
      end

      def setup_solid_queue
        gsub_file "config/environments/development.rb", "config.cache_store = :memory_store", <<-RUBY.strip
  # Replace the default in-process memory cache store with a durable alternative.
  config.cache_store = :solid_cache_store

  # Replace the default in-process and non-durable queuing backend for Active Job.
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = {database: {writing: :queue}}
        RUBY

        # delete config/recurring.yml
        remove_file "config/recurring.yml"
        generate "solid_queue:install"
        generate "solid_cache:install"
        generate "solid_cable:install"

        gsub_file "config/environments/development.rb", /config\.active_job\.queue_adapter = Jumpstart\.config\.queue_adapter/, ""
        gsub_file "config/environments/production.rb", /config\.active_job\.queue_adapter = Jumpstart\.config\.queue_adapter/, ""
      end

      def procfile
        insert_into_file "Procfile", "\nworker: bin/jobs\n"
        insert_into_file "Procfile.dev", "\nworker: bin/jobs\n"
      end

      def copy_config_files
        directory "config/configs", "config/configs"
        copy_file "config/database.yml", "config/database.yml", force: true
        copy_file "config/cable.yml", "config/cable.yml", force: true
      end

      def kamal_deployment
        template "config/deploy.yml.tt", "config/deploy.yml", force: true
      end

      def kamal_secrets
        insert_into_file ".kamal/secrets", <<-SHELL.strip
          # Either use .env or rails credentials to store database password.
          # POSTGRES_PASSWORD=<%= ENV.fetch("POSTGRES_PASSWORD", "password") %>
          credentials=$(bin/rails credentials:show --environment production)
          POSTGRES_PASSWORD=$(echo "$credentials" | yq '.database.primary.password // "password"')
          POSTGRES_USER=$(echo "$credentials" | yq '.database.primary.username // "postgres"')
        SHELL
      end

      def credentials_file
        insert_into_file "lib/templates/rails/credentials/credentials.yml.tt", before: "active_record_encryption:" do
          <<~YAML
            database:
              primary:
                username: postgres
                password: <%= SecureRandom.alphanumeric(32) %>

          YAML
        end
      end

      def env_file
        template ".env.tt", ".env", force: true
      end

      def jumpstart_yml
        template "config/jumpstart.yml.tt", "config/jumpstart.yml"
      end

      private

      def application_js_path(ext)
        javascripts_dir("application#{ext}")
      end

      def detect_js_format
        %w[.js .js.erb .coffee .coffee.erb .js.coffee .js.coffee.erb].each do |ext|
          next unless File.exist?(javascripts_dir("application#{ext}"))
          return [ext, "#="] if ext.include?(".coffee")

          return [ext, "//="]
        end
      end

      def detect_layout
        layouts = %w[.html.erb .html.haml .html.slim .erb .haml .slim].map { |ext|
          layouts_dir("application#{ext}")
        }
        layouts.find { |layout| File.exist?(layout) }
      end

      def app_name
        File.basename(destination_root)
      end

      def app_name_underscore
        app_name.tr("-", "_")
      end

      def app_name_dasherized
        app_name.tr("_", "-")
      end

      def app_name_titleized
        app_name.titleize
      end

      def javascripts_dir(*paths)
        join("app", "assets", "javascripts", *paths)
      end

      def initializers_dir(*paths)
        join("config", "initializers", *paths)
      end

      def layouts_dir(*paths)
        join("app", "views", "layouts", *paths)
      end

      def public_dir(*paths)
        join("public", *paths)
      end

      def join(*paths)
        File.expand_path(File.join(*paths), destination_root)
      end

      def conditional_warn(warning)
        silenced? || warn(warning)
      end

      def silenced?
        ENV["RAILS_ENV"] == "test"
      end

      def move_file(source, destination)
        source = File.expand_path(source.to_s, destination_root)
        destination = File.expand_path(destination.to_s, destination_root)
        FileUtils.mv(source, destination)
      end

      def postgres_password
        @postgres_password ||= SecureRandom.hex(16)
      end
    end
  end
end
