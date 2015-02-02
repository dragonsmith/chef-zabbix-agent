#
# Author:: Maxim Filatov (bregor@evilmartians.com)
# Cookbook Name:: zabbix-agent
# Library:: md_array_finder
#
# Copyright 2015, Maxim Filatov
#
# Licensed under the MIT License

module ZabbixAgent
  module MdArrayFinderHelper
    def md_arrays_exists?
      !File.readlines('/proc/mdstat').grep(/md/).empty?
    rescue Errno::ENOENT
      false
    end
  end
end

class Chef::Recipe
  include ZabbixAgent::MdArrayFinderHelper
end

class Chef::Resource
  include ZabbixAgent::MdArrayFinderHelper
end
