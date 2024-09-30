# frozen_string_literal: true

require_relative "rails_config"

# monkey patch to make sure people don't use a bare Redis.current without passing in the right SSL options
class Redis
  def self.current
    raise "Please call RedisConfig.redis or RedisConfig.redis(cache: true) instead of Redis.current"
  end
end

# This class manages config vars for both REDIS_* and REDIS_CACHE_*
# to help us intercept a variety of `Redis.current` or `Redis.new` calls
# and inject the correct SSL settings for Heroku.
# see
# * https://github.com/rails/kredis/blob/main/README.md#setting-ssl-options-on-redis-connections
# * https://help.heroku.com/HC0F8CUS/redis-connection-issues
# * https://ogirginc.github.io/en/heroku-redis-ssl-error
class RedisConfig < ApplicationConfig
  attr_config :url, :tls_url, :cache_url, :cache_tls_url
  attr_config debug: false
  required :url if Rails.env.production?

  def url
    tls_url || super || "redis://localhost:6379"
  end

  def cache_url
    cache_tls_url || super || url
  end

  # these are factories for singletons
  # maybe they should live in a separate RedisFactory but for now they're here
  def redis(cache: false)
    if cache
      @_redis_cache ||= new_redis(cache: true)
    else
      @_redis ||= new_redis(cache: false)
    end
  end

  # RedisConfig.redis_config returns a hash to pass to Redis.new
  def redis_config(cache: false, config: {})
    url = cache ? url : cache_url
    url += "/3" if Rails.env.test?
    {
      url: url,
      ssl_params: {
        verify_mode: OpenSSL::SSL::VERIFY_NONE
      }
    }.merge(config)
  end

  protected

  def new_redis(cache: false, config: {})
    config = redis_config(cache: cache, config: config)
    puts "Making new Redis connection to #{config[:url]}" if RedisConfig.debug
    Redis.new(config)
  end
end
