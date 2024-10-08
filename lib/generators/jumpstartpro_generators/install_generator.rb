# frozen_string_literal: true

require "rails/generators"
require "fileutils"

module JumpstartproGenerators
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Install Scope & Go defaults into Jumpstart Pro"
      source_root File.join(File.dirname(__FILE__), "templates")

      def add_gemfile_entries
        gem "anyway_config"
        run "bundle install"
      end

      def copy_config_files
        directory "config/configs", "config/configs"
        copy_file "config/database.yml", "config/database.yml", force: true
        copy_file "config/cable.yml", "config/cable.yml", force: true
      end

      def copy_initializers
        directory "config/initializers", "config/initializers"
      end

      def editor_settings
        copy_file ".cursorrules", ".cursorrules"
      end

      def bin_setup_updates
        # replace '  system! "bin/rails db:prepare"' with '  system! "bin/rails db:schema:load db:seed"'
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
    end
  end
end
