# frozen_string_literal: true

module GeneratorTestHelpers
  def self.included(base)
    base.extend ClassMethods
  end

  def evaluate_erb_asset_template(template)
    engine = ::ERB.new(template)
    asset_binding = asset_context_class.new.context_binding
    engine.result(asset_binding)
  end

  def asset_context_class
    Class.new do
      def image_path(name)
        "/assets/#{name}"
      end

      def context_binding
        binding
      end
    end
  end

  module ClassMethods
    def tmp_path
      File.expand_path("../../tmp", File.dirname(__FILE__))
    end

    def create_generator_sample_app
      local = ENV["LOCAL_JSP_CLONE"]
      if local && File.directory?(File.expand_path(local))
        local = File.expand_path(local)
        warn "Using local jumpstart-pro-rails: #{local}"
        system "git clone #{local} #{tmp_path}/rails_app"
      else
        warn "Using remote jumpstart-pro-rails"
        system "git clone https://drnic:#{ENV["GH_TOKEN"]}@github.com/scopeandgo/jumpstart-pro-rails.git #{tmp_path}/rails_app"
      end
      # system "cd #{tmp_path}/rails_app && bundle update"
    end

    def remove_generator_sample_app
      FileUtils.rm_rf(destination_root)
    end
  end
end
