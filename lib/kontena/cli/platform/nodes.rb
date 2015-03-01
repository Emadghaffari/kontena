require 'kontena/client'
require_relative '../common'
module Kontena::Cli::Platform
  class Nodes
    include Kontena::Cli::Common

    def list
      require_api_url
      token = require_token

      grids = client(token).get("grids/#{current_grid}/nodes")
      puts "%-20s %-20s %-10s %-20s %-10s" % ['Name', 'OS', 'Driver', 'Labels', 'Status']
      rows = []
      grids['nodes'].each do |node|
        if node['connected']
          status = 'online'
        else
          status = 'offline'
        end
        puts "%-20.20s %-20.20s %-10s %-20.20s %-10s" % [
          node['name'],
          node['os'],
          node['driver'],
          (node['labels'] || ['-']).join(","),
          status
        ]
      end
    end

    def show(id)
      require_api_url
      token = require_token

      node = client(token).get("grids/#{current_grid}/nodes/#{id}")
      puts "#{node['name']}:"
      puts "  id: #{node['id']}"
      puts "  connected: #{node['connected'] ? 'yes': 'no'}"
      puts "  last connect: #{node['updated_at']}"
      puts "  os: #{node['os']}"
      puts "  driver: #{node['driver']}"
      puts "  kernel: #{node['kernel_version']}"
      puts "  cpus: #{node['cpus']}"
      puts "  memory: #{node['mem_total'] / 1024 / 1024}M"
      puts "  labels:"
      if node['labels']
        node['labels'].each{|l| puts "    - #{l}"}
      end
    end

    def destroy(id)
      require_api_url
      token = require_token

      node = client(token).delete("grids/#{current_grid}/nodes/#{id}")
    end

    private

    def current_grid
      inifile['platform']['grid']
    end
  end
end
