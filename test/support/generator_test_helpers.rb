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
    def test_path
      File.join(File.dirname(__FILE__), "..")
    end

    def tmp_path
      File.expand_path("../../tmp", File.dirname(__FILE__))
    end

    def create_generator_sample_app
      FileUtils.mkdir_p(tmp_path)
      FileUtils.cd(tmp_path) do
        system "rails new rails_app --skip-active-record --skip-test-unit --skip-spring --skip-bundle --quiet"
      end
      inject_jumpstart_pro_files
    end

    # Copy files in test/support/files to the tmp app
    def inject_jumpstart_pro_files
      Dir[File.join(test_path, "support/files/**/*")].each do |file|
        FileUtils.mkdir_p(File.dirname(file))
        FileUtils.cp_r(file, destination_root)
      end
    end

    def remove_generator_sample_app
      FileUtils.rm_rf(destination_root)
    end
  end
end
