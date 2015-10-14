#
# Cookbook Name:: zabbix-agent
# Library:: redis_helpers
#
# Author:: Kirill Kouznetsov <agon.smith@gmail.com>
#
# Copyright (C) 2015, Evil Martians
#

module Zabbix
  module Redis
    # This helper provides three functions to get redis configuration parameters.
    module Helpers
      REDIS_CONFIG = '/etc/redis/redis.conf'

      def get_redis_host(config = REDIS_CONFIG)
        ::File.open(config, 'r').grep(/^\s*bind\s/, &:split).first[1]
      end

      def get_redis_port(config = REDIS_CONFIG)
        ::File.open(config, 'r').grep(/^\s*port\s/, &:split).first[1].to_i
      end

      def get_redis_password(config = REDIS_CONFIG)
        ::File.open(config, 'r').grep(/^\s*requirepass\s/, &:split).first[1]
      end
    end
  end
end

class Chef
  # extending default chef class
  class Recipe
    include Zabbix::Redis::Helpers
  end
end

class Chef
  # extending default chef class
  class Resource
    include Zabbix::Redis::Helpers
  end
end
