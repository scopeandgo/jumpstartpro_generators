# frozen_string_literal: true

require "anyway_config"
require "active_support/core_ext/module/delegation"

# AnywayConfig will pull configuration attributes from any of 4 possible sources:
# (ordered by priority from low to high)
#
# 1. YAML configuration files: `RAILS_ROOT/config/my_cool_gem.yml`
# 2. Rails secrets: `Rails.application.secrets.my_cool_gem` (if secrets.yml present)
# 3. Rails credentials: `Rails.application.credentials.my_cool_gem` (if supported)
# 4. Environment variables: `ENV['MYCOOLGEM_*']`
#
# see further — https://github.com/palkan/anyway_config#data-population

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  class << self
    # Make it possible to access a singleton config instance
    # via class methods (i.e., without explictly calling `instance`)
    delegate_missing_to :instance

    private

    # Returns a singleton config instance
    def instance
      @instance ||= new
    end
  end
end
